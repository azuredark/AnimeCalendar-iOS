//
//  FeedDataSource.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 22/11/22.
//

import UIKit

protocol FeedDataSourceable {
    func updateSnapshot(for section: FeedSection, with: [AnyHashable], animating: Bool)
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
    private var existingSections = [FeedSection]()

    // MARK: Initializers
    init(for collectionView: UICollectionView, presenter: DiscoverPresentable?) {
        self.collectionView = collectionView
        self.presenter = presenter

        configureCollection()
        buildDataSource()
    }

    // MARK: Provider
    private func buildDataSource() {
        dataSource = DiffableDataSource(collectionView: collectionView) { [weak self] collectionView, indexPath, item in
            let section = FeedSection.allCases[indexPath.section]
            switch section {
                case .animeSeason, .animeTop:
                    let seasonAnimeCell: SeasonAnimeCell = Self.getCell(with: collectionView, at: indexPath)
                    guard let anime = item as? Anime else { return seasonAnimeCell }
                    
                    seasonAnimeCell.anime = anime
                    seasonAnimeCell.presenter = self?.presenter
                    seasonAnimeCell.setup()
                    return seasonAnimeCell
                case .animePromos:
                    let promoAnimeCell: PromoAnimeCell = Self.getCell(with: collectionView, at: indexPath)
                    guard let promo = item as? Promo else { return promoAnimeCell }
                    
                    promoAnimeCell.promo = promo
                    promoAnimeCell.presenter = self?.presenter
                    promoAnimeCell.setup()
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
    func updateSnapshot(for section: FeedSection, with items: [AnyHashable], animating: Bool = false) {
        print("senku [DEBUG] \(String(describing: type(of: self))) - UPDATE SNAPSHOT! - section: \(section.rawValue) | items: \(items)")
        if !existingSections.contains(section) {
            currentSnapshot.appendSections([section])
            existingSections.append(section)
        }
        currentSnapshot.appendItems(items, toSection: section)
        dataSource?.apply(currentSnapshot, animatingDifferences: animating)
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
    case animePromos = "Promos"
    case animeTop    = "All-Time Top Anime"
}

/// All item types
enum FeedItem: CaseIterable {
    case anime
    case promo
}
