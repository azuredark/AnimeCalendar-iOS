//
//  FeedDataSource.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 22/11/22.
//

import UIKit

protocol FeedDataSourceable {
    func updateSnapshot<T: CaseIterable, O: Hashable & ModelSectionable>(for section: T, with items: [O], animating: Bool, before: T?, after: T?, deleteLoaders: Bool)
    /// Sets the **section** for an specific item.
    func setModelSection<T: CaseIterable, O: Hashable>(for section: T, with items: [O]) -> [any ModelSectionable]
    func setModelSection<T: CaseIterable, O: Hashable>(for section: T, with items: [O]) -> [AnyHashable]
    func getItem<T: Hashable>(at indexPath: IndexPath) -> T?
}

extension FeedDataSourceable {
    func setModelSection<T: CaseIterable, O: Hashable>(for section: T, with items: [O]) -> [any ModelSectionable] {
        return [Anime]()
    }

    func setModelSection<T: CaseIterable, O: Hashable>(for section: T, with items: [O]) -> [AnyHashable] {
        return [AnyHashable]()
    }
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
        /// # Cells
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

        let animeSeasonLoaderCell = UICollectionView.CellRegistration<AnimeSeasonLoaderCell, any ModelSectionable> { (cell, _, _) in
            cell.setup()
        }
        let animePromoLoaderCell = UICollectionView.CellRegistration<AnimePromoLoaderCell, any ModelSectionable> { (cell, _, _) in
            cell.setup()
        }
        let animeTopLoaderCell = UICollectionView.CellRegistration<AnimeTopLoaderCell, any ModelSectionable> { (cell, _, _) in
            cell.setup()
        }

        dataSource = DiffableDataSource(collectionView: collectionView) { collectionView, indexPath, item in
            guard let item = item as? (any ModelSectionable) else { return nil }
            let section: FeedSection = item.feedSection
            
            switch section {
                case .animeSeason:
                    if item.isLoading {
                        return collectionView.dequeueConfiguredReusableCell(using: animeSeasonLoaderCell, for: indexPath, item: item)
                    }
                    guard let anime = item as? Anime else { return nil }
                    return collectionView.dequeueConfiguredReusableCell(using: seasonAnimeCell, for: indexPath, item: anime)
                case .animePromos:
                    if item.isLoading {
                        return collectionView.dequeueConfiguredReusableCell(using: animePromoLoaderCell, for: indexPath, item: item)
                    }
                    guard let promo = item as? Promo else { return nil }
                    return collectionView.dequeueConfiguredReusableCell(using: promoAnimeCell, for: indexPath, item: promo)
                case .animeTop:
                    if item.isLoading {
                        return collectionView.dequeueConfiguredReusableCell(using: animeTopLoaderCell, for: indexPath, item: item)
                    }
                    guard let anime = item as? Anime else { return nil }
                    return collectionView.dequeueConfiguredReusableCell(using: topAnimeCell, for: indexPath, item: anime)
                case .unknown: return nil
            }
        }

        // Supplementary views
        dataSource?.supplementaryViewProvider = { [weak self] (collection, kind, indexPath) -> UICollectionReusableView? in
            let headerView = collection.dequeueReusableSupplementaryView(ofKind: kind,
                                                                         withReuseIdentifier: FeedHeader.reuseIdentifier,
                                                                         for: indexPath) as? FeedHeader
            
            // If error, then send emptyheader
            guard let item = self?.getItem(at: indexPath) as? (any ModelSectionable) else {
                return collection.dequeueReusableSupplementaryView(ofKind: kind,
                                                                   withReuseIdentifier: EmptyHeader.reuseIdentifier,
                                                                   for: indexPath) as? EmptyHeader
            }
            
            let section = item.feedSection
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
    func setModelSection<T, O>(for section: T, with items: [O]) -> [AnyHashable] where T: CaseIterable, O: Hashable {
        return [Anime]()
    }

    /// Updates the current snapshot
    /// - Parameter section: The section to update
    /// - Parameter animes: The animes to update for the specified section
    /// Updates the **items** for the current **section**
    func updateSnapshot<T: CaseIterable, O: Hashable & ModelSectionable>(for section: T, with items: [O], animating: Bool, before: T? = nil, after: T? = nil, deleteLoaders: Bool = false) {
        guard let section = section as? FeedSection else { return }

        // Create section
        if currentSnapshot.indexOfSection(section) == nil {
            currentSnapshot.appendSections([section])
        }

        // Remove loaders from snapshot.
        if deleteLoaders { removeLoaders(in: section) }

        currentSnapshot.appendItems(items, toSection: section)

        dataSource?.apply(currentSnapshot, animatingDifferences: animating)
    }

    /// Get item at **index path**
    /// - Parameter indexPath: Index path of the collection view.
    /// - Returns: Item of the generic inferred type.
    func getItem<T: Hashable>(at indexPath: IndexPath) -> T? {
        return dataSource?.itemIdentifier(for: indexPath) as? T
    }
    
    func getItem(at indexPath: IndexPath) -> AnyHashable {
        return dataSource?.itemIdentifier(for: indexPath)
    }

    func removeLoaders(in section: FeedSection) {
        // Find loaders
        let loaders = currentSnapshot.itemIdentifiers(inSection: section)
            .compactMap { $0 as? (any ModelSectionable)}.filter(\.isLoading)
        
        // Remove loaders from snapshot
        if let itemsToRemove = loaders as? [AnyHashable] {
            currentSnapshot.deleteItems(itemsToRemove)
        }
    }
    
    func resetSnapshot() {
        currentSnapshot.deleteAllItems()
        currentSnapshot.deleteSections([.animeSeason, .animePromos, .animeTop])
        let emptySnapshot = Snapshot()
        dataSource?.apply(emptySnapshot, animatingDifferences: true)
    }
}

/// All section types
enum FeedSection: String, CaseIterable {
    case animeSeason = "Current Season"
    case animePromos = "Promos"
    case animeTop    = "Top All-time"
    case unknown     = "Unknown"

    var placeholderCount: Int {
        switch self {
            case .animeSeason, .animePromos, .animeTop:
                return 10
            case .unknown: return 0
        }
    }
}
