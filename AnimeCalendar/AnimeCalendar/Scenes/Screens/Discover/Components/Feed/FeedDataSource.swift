//
//  FeedDataSource.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 22/11/22.
//

import UIKit

protocol FeedDataSourceable {
    /// Sets the **section** for an specific item.
    func setModelSection<T: CaseIterable, O: Hashable>(for section: T, with items: [O]) -> [AnyHashable]
    func getItem<T: Hashable>(at indexPath: IndexPath) -> T?
    func updateSnapshot<T: Hashable>(for section: DetailFeedSection,
                                     with items: [T],
                                     animating: Bool,
                                     before: DetailFeedSection?,
                                     after: DetailFeedSection?,
                                     deleteLoaders: Bool)
}

extension FeedDataSourceable {
    func setModelSection<T: CaseIterable, O: Hashable>(for section: T, with items: [O]) -> [AnyHashable] {
        return [AnyHashable]()
    }
    
    func getItem<T: Hashable>(at indexPath: IndexPath) -> T? { nil }
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
        let seasonAnimeCell = UICollectionView.CellRegistration<SeasonAnimeCell, Anime> { [weak self] cell, _, anime in
            cell.anime = anime
            cell.presenter = self?.presenter
            cell.setup()
        }

        let upcomingAnimeCell = UICollectionView.CellRegistration<UpcomingAnimeCell, Anime> { cell, _, anime in
            cell.anime = anime
            cell.setup()
        }

        let promoAnimeCell = UICollectionView.CellRegistration<PromoAnimeCell, Promo> { [weak self] cell, _, promo in
            cell.promo = promo
            cell.presenter = self?.presenter
            cell.setup()
        }

        let topAnimeCell = UICollectionView.CellRegistration<TopAnimeCell, Anime> { [weak self] (cell, indexPath, anime) in
            cell.anime = anime
            cell.index = indexPath.row + 1
            cell.presenter = self?.presenter
            cell.setup()
        }

        let loaderCell = UICollectionView.CellRegistration<ACLoaderCell, LoadingPlaceholder> { (cell, _, _) in
            cell.setup()
        }

        let loadMoreItemsCell = UICollectionView.CellRegistration<ACLoadMoreItemsCell, LoadingSpinner> { (cell, _, _) in
            cell.setup()
        }

        dataSource = DiffableDataSource(collectionView: collectionView) { [weak presenter] collectionView, indexPath, item in
            guard let item = item as? Content, let presenter else { return nil }
            // Loading-Cell (Placeholder).
            if let item = item as? LoadingPlaceholder {
                return collectionView.dequeueConfiguredReusableCell(using: loaderCell, for: indexPath, item: item)
            }

            // Loading-More-Items cell.
            if let item = item as? LoadingSpinner {
                // Handle pagination.
                let section = item.feedSection
                presenter.handlePagination(for: section)
                return collectionView.dequeueConfiguredReusableCell(using: loadMoreItemsCell, for: indexPath, item: item)
            }

            let section: FeedSection = item.feedSection
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
                case .animeUpcoming:
                    guard let anime = item as? Anime else { return nil }
                    return collectionView.dequeueConfiguredReusableCell(using: upcomingAnimeCell, for: indexPath, item: anime)
                case .unknown: return nil
            }
        }

        // Supplementary views
        dataSource?.supplementaryViewProvider = { [weak self] (collection, kind, indexPath) -> UICollectionReusableView? in
            let headerView = collection.dequeueReusableSupplementaryView(ofKind: kind,
                                                                         withReuseIdentifier: FeedHeader.reuseIdentifier,
                                                                         for: indexPath) as? FeedHeader

            // If error, then send emptyheader
            guard let item = self?.getItem(at: indexPath) as? Content else {
                return collection.dequeueReusableSupplementaryView(ofKind: kind,
                                                                   withReuseIdentifier: EmptyHeader.reuseIdentifier,
                                                                   for: indexPath) as? EmptyHeader
            }

            let section = item.feedSection
            let model = FeedHeaderModel(text: section.rawValue)
            headerView?.setup(with: model)
            return headerView
        }
    }

    private func configureCollection() {
        // MARK: Cells
        // Season anime
        collectionView.register(SeasonAnimeCell.self, forCellWithReuseIdentifier: SeasonAnimeCell.reuseIdentifier)
        // Upcoming anime
        collectionView.register(UpcomingAnimeCell.self, forCellWithReuseIdentifier: UpcomingAnimeCell.reuseIdentifier)
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

extension FeedDataSource {
    /// Updates the current snapshot
    /// - Parameter section: The section to update
    /// - Parameter animes: The animes to update for the specified section
    /// Updates the **items** for the current **section**
    func updateSnapshot<T: CaseIterable, O: Hashable>(for section: T, with items: [O], animating: Bool, before: T? = nil, after: T? = nil, deleteLoaders: Bool = false) {
        guard let section = section as? FeedSection else { return }

        // Create new snapshot from the current one.
        guard var currentSnapshot = dataSource?.snapshot() else { return }

        // Create section
        if currentSnapshot.indexOfSection(section) == nil {
            currentSnapshot.appendSections([section])
        }

        // Delete items section before adding more, as the items may be aggregated and result in duplicated items in snapshot.
        currentSnapshot.deleteItems(currentSnapshot.itemIdentifiers(inSection: section))

        // Add items.
        currentSnapshot.appendItems(items, toSection: section)

        // Apply the snapshot.
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

    func resetSnapshot() {
        currentSnapshot.deleteAllItems()
        let emptySnapshot = Snapshot()
        dataSource?.apply(emptySnapshot, animatingDifferences: true)
    }
}

/// All section types
enum FeedSection: String, CaseIterable {
    case animePromos   = "📺 Promos"
    case animeSeason   = "🔥 Current Season"
    case animeUpcoming = "📅 Upcoming"
    case animeTop      = "🏆 Top All-time"
    case unknown       = "Unknown"

    var placeholderCount: Int {
        switch self {
            case .animeSeason, .animeTop, .animeUpcoming:
                return 10
            case .animePromos:
                return 5
            case .unknown: return 0
        }
    }
}
