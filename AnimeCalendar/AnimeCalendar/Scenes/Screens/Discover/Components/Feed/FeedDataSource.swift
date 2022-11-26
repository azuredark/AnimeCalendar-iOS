//
//  FeedDataSource.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 22/11/22.
//

import UIKit

protocol FeedDataSourceable {
    func updateSnapshot(for section: FeedSection, with: [Anime], animating: Bool)
}

final class FeedDataSource {
    // MARK: Aliases
    private typealias DiffableDataSource = UICollectionViewDiffableDataSource<FeedSection, Anime>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<FeedSection, Anime>

    // MARK: State
    private let collectionView: UICollectionView
    private var dataSource: DiffableDataSource?
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
        dataSource = DiffableDataSource(collectionView: collectionView) { [weak self] collectionView, indexPath, anime in
            let section = FeedSection.allCases[indexPath.section]
            switch section {
                case .animeSeason, .animeTop:
                    let seasonAnimeCell: SeasonAnimeCell = Self.getCell(with: collectionView, at: indexPath)
                    seasonAnimeCell.anime = anime
                    seasonAnimeCell.presenter = self?.presenter
                    seasonAnimeCell.setup()
                    return seasonAnimeCell
                case .animePromos:
                    let promoAnimeCell: PromoAnimeCell = Self.getCell(with: collectionView, at: indexPath)
                    promoAnimeCell.presenter = self?.presenter
                    return promoAnimeCell
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
    func updateSnapshot(for section: FeedSection, with items: [Anime], animating: Bool = false) {
        var snapshot = Snapshot()
        snapshot.appendSections([section])
        snapshot.appendItems(items, toSection: section)
        dataSource?.apply(snapshot, animatingDifferences: animating)
    }
}

// MARK: - Private implementations
private extension FeedDataSource {
    static func getCell<T: FeedCell>(with collection: UICollectionView, at indexPath: IndexPath) -> T {
        guard let cell = collection.dequeueReusableCell(withReuseIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            fatalError("ACError - Error dequeing cell of type: \(T.self)")
        }
        return cell
    }
}

/// All section types
enum FeedSection: String, CaseIterable {
    case animeSeason = "Current Season"
    case animeTop    = "All-Time Top Anime"
    case animePromos = "Promos"
}

/// All item types
enum FeedItem: CaseIterable {
    case anime
    case promo
}
