//
//  FeedDataSource.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 22/11/22.
//

import UIKit

protocol FeedDataSourceable {
    func updateSnapshot<T: CaseIterable, O: Hashable>(for section: T, with items: [O], animating: Bool, before: T?, after: T?)
    /// Sets the **section** for an specific item.
    func setModelSection<T: CaseIterable, O: Hashable>(for section: T, with items: [O]) -> [AnyHashable]
    func getItem<T: Hashable>(at indexPath: IndexPath) -> T?
}

final class FeedDataSource {
    // MARK: Aliases
    private typealias DiffableDataSource = UICollectionViewDiffableDataSource<FeedSection, AnyHashable>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<FeedSection, AnyHashable>

    // MARK: State
    private let collectionView: UICollectionView
    private var dataSource: DiffableDataSource?
    private var currentSnapshot = Snapshot()
    private weak var presenter: DiscoverPresentable?

    // MARK: Initializers
    init(for collectionView: UICollectionView, presenter: DiscoverPresentable?) {
        self.collectionView = collectionView
        self.presenter = presenter

        configureCollection()
        buildDataSource()
    }

    // MARK: Provider
    private func buildDataSource() {
        let seasonAnimeCell = UICollectionView.CellRegistration<SeasonAnimeCell, Anime> {
            [weak self] cell, _, anime in
            cell.anime = anime
            cell.presenter = self?.presenter
            cell.setup()
        }

        let promoAnimeCell = UICollectionView.CellRegistration<PromoAnimeCell, Promo> {
            [weak self] cell, _, promo in
            cell.promo = promo
            cell.presenter = self?.presenter
            cell.setup()
        }

        let topAnimeCell = UICollectionView.CellRegistration<TopAnimeCell, Anime> {
            [weak self] cell, indexPath, anime in
            cell.anime = anime
            cell.index = indexPath.row + 1
            cell.presenter = self?.presenter
            cell.setup()
        }

        dataSource = DiffableDataSource(collectionView: collectionView) { collectionView, indexPath, item in
            guard let item = item as? (any ModelSectionable) else { return nil }
            let section: FeedSection = item.feedSection
//            let section = FeedSection.allCases[indexPath.section]
            switch section {
                case .animeSeason:
                    guard let anime = item as? Anime else { return nil }
                    return collectionView.dequeueConfiguredReusableCell(using: seasonAnimeCell, for: indexPath, item: anime)
                case .animePromos:
                    guard let promo = item as? Promo else { return nil }
                    return collectionView.dequeueConfiguredReusableCell(using: promoAnimeCell, for: indexPath, item: promo)
                case .animeTop:
                    guard let anime = item as? Anime else { return nil }
                    return collectionView.dequeueConfiguredReusableCell(using: topAnimeCell, for: indexPath, item: anime)
            }
        }

        // Supplementary views
        dataSource?.supplementaryViewProvider = { collection, kind, indexPath -> UICollectionReusableView? in
            let headerView = collection.dequeueReusableSupplementaryView(ofKind: kind,
                                                                         withReuseIdentifier: FeedHeader.reuseIdentifier,
                                                                         for: indexPath) as? FeedHeader
            let section = FeedSection.allCases[indexPath.section]
            headerView?.setupTitle(with: section.rawValue)
            return headerView
        }
    }

    private func configureCollection() {
        // MARK: Cells
        // Season anime
        collectionView.register(SeasonAnimeCell.self, forCellWithReuseIdentifier: SeasonAnimeCell.reuseIdentifier)
        // Promos trailers
        collectionView.register(PromoAnimeCell.self, forCellWithReuseIdentifier: PromoAnimeCell.reuseIdentifier)
        // Top anime
        collectionView.register(TopAnimeCell.self, forCellWithReuseIdentifier: TopAnimeCell.reuseIdentifier)

        // MARK: Headers
        // Generic header
        collectionView.register(FeedHeader.self,
                                forSupplementaryViewOfKind: Feed.sectionHeaderKind,
                                withReuseIdentifier: FeedHeader.reuseIdentifier)
    }
}

extension FeedDataSource: FeedDataSourceable {
    /// Updates the current snapshot
    /// - Parameter section: The section to update
    /// - Parameter animes: The animes to update for the specified section
    /// Updates the **items** for the current **section**
    func updateSnapshot<T: CaseIterable, O: Hashable>(for section: T, with items: [O], animating: Bool, before: T? = nil, after: T? = nil) {
        guard let section = section as? FeedSection else { return }
        let newItems = setModelSection(for: section, with: items)
        
        if currentSnapshot.indexOfSection(section) == nil {
            currentSnapshot.appendSections([section])
        }
        currentSnapshot.appendItems(newItems, toSection: section)
        dataSource?.apply(currentSnapshot, animatingDifferences: animating)
    }
    
    func setModelSection<T: CaseIterable, O: Hashable>(for section: T, with items: [O]) -> [AnyHashable] {
        guard let section = section as? FeedSection else { return [] }
        var items = items.compactMap { $0 as? (any ModelSectionable) }
        items.indices.forEach { items[$0].feedSection = section }
        guard let finalItems = items as? [AnyHashable] else { return [] }
        return finalItems
    }

    /// Get item at **index path**
    /// - Parameter indexPath: Index path of the collection view.
    /// - Returns: Item of the generic inferred type.
    func getItem<T: Hashable>(at indexPath: IndexPath) -> T? {
        return dataSource?.itemIdentifier(for: indexPath) as? T
    }
}

/// All section types
enum FeedSection: String, CaseIterable {
    case animeSeason = "Current Season"
    case animePromos = "Promos"
    case animeTop    = "Top All-time"
}
