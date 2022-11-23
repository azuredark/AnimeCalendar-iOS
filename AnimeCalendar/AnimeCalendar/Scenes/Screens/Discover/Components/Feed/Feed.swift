//
//  Feed.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 22/11/22.
//

import UIKit
import RxSwift
import RxCocoa

final class Feed {
    // MARK: State
    static let sectionHeaderKind: String = "SECTION_HEADER_ELEMENT_KIND"
    private lazy var containerCollection: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: getLayout())
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.backgroundColor = .clear
        return collection
    }()

    private let discoverFeed: DiscoverFeed?

    /// # DataSource
    private lazy var dataSource: FeedDataSource = {
        FeedDataSource(for: containerCollection)
    }()

    private let disposeBag = DisposeBag()

    // MARK: Initializers
    init(listeningTo discoverFeed: DiscoverFeed?) {
        self.discoverFeed = discoverFeed
        configureBindings()
    }

    // MARK: Methods
    func getCollection() -> UICollectionView {
        return containerCollection
    }
}

private extension Feed {
    func getLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] sectionIndex, _ in
            guard let strongSelf = self else { fatalError("No Feed reference while generating collection layout") }
            let section = FeedSection.allCases[sectionIndex]
            switch section {
                case .seasonAnime, .topAnime:
                    return strongSelf.getSeasonAnimeSection()
            }
        }
        return layout
    }

    func getSeasonAnimeSection() -> NSCollectionLayoutSection {
        // Item
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        // Group
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(180.0),
                                               heightDimension: .absolute(280.0))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.contentInsets = .init(top: 0, leading: 2, bottom: 0, trailing: 2)
        
        // Header
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                heightDimension: .estimated(44))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize,
                                                                 elementKind: Self.sectionHeaderKind,
                                                                 alignment: .top)

        // Section
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.boundarySupplementaryItems = [header]

        return section
    }
}

extension Feed: Bindable {
    func configureBindings() {
        bindFeed()
    }

    func bindFeed() {
        #warning("THIS COULD BE IMPROVED")
        guard let discoverFeed = discoverFeed else { return }
        let seasonAnimeFeed = discoverFeed.seasonAnime
//        let topAnimeFeed = discoverFeed.topAnime
        seasonAnimeFeed.driver.drive { [weak self] animes in
            guard let strongSelf = self else { return }
            print("senku [DEBUG] \(String(describing: type(of: self))) - updateSnapshot with: \(animes.map { $0.title })")
            strongSelf.dataSource.updateSnapshot(for: seasonAnimeFeed.section, with: animes)
        }.disposed(by: disposeBag)
    }
}

/// All section types
enum FeedSection: String, CaseIterable {
    case seasonAnime = "Current Season"
    case topAnime = "All-Time Top Anime"
}
