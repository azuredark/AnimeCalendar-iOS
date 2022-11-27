//
//  Feed.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 22/11/22.
//

import UIKit
import RxSwift
import RxCocoa

final class Feed: NSObject {
    // MARK: State
    static let sectionHeaderKind: String = "SECTION_HEADER_ELEMENT_KIND"
    private lazy var containerCollection: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: getLayout())
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.backgroundColor = .clear
        collection.showsVerticalScrollIndicator = false
        collection.showsHorizontalScrollIndicator = false
        return collection
    }()

    private weak var presenter: DiscoverPresentable?

    /// # DataSource
    private lazy var dataSource: FeedDataSource = {
        FeedDataSource(for: containerCollection, presenter: presenter)
    }()

    private var cellIsSelectable: Bool = true

    private let disposeBag = DisposeBag()

    // MARK: Initializers
    init(presenter: DiscoverPresentable?) {
        super.init()
        self.presenter = presenter

        containerCollection.delegate = self
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
                case .animeSeason, .animeTop:
                    return strongSelf.getAnimeSeasonSection()
                case .animePromos:
                    return strongSelf.getAnimePromosSection()
            }
        }
        return layout
    }

    func getAnimeSeasonSection() -> NSCollectionLayoutSection {
        // Item
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        // Group
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(170.0),
                                               heightDimension: .absolute(280.0))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        //        group.contentInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 30.0)

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
        section.contentInsets = .init(top: 0, leading: 20.0, bottom: 15.0, trailing: 20.0)
        section.interGroupSpacing = 30.0

        return section
    }

    func getAnimePromosSection() -> NSCollectionLayoutSection {
        // Item
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        // Group
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.65),
                                               heightDimension: .fractionalWidth(1/3))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        // Header
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                heightDimension: .estimated(44))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize,
                                                                 elementKind: Self.sectionHeaderKind,
                                                                 alignment: .top)

        // Section
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
        section.boundarySupplementaryItems = [header]
        section.contentInsets = .init(top: 0, leading: 20.0, bottom: 0, trailing: 20.0)
        section.interGroupSpacing = 30.0

        return section
    }
}

extension Feed: Bindable {
    func configureBindings() {
        bindFeed()
    }

    func bindFeed() {
        #warning("THIS COULD BE IMPROVED")
        guard let discoverFeed = presenter?.feed else { return }

        let seasonAnimeFeed = discoverFeed.seasonAnime
        seasonAnimeFeed.driver.drive { [weak self] animes in
            guard let strongSelf = self else { return }
            strongSelf.dataSource.updateSnapshot(for: seasonAnimeFeed.section, with: animes, animating: true)
        }.disposed(by: disposeBag)

        let recentPromosAnimeFeed = discoverFeed.recentPromosAnime
        recentPromosAnimeFeed.driver.drive { [weak self] promos in
            guard let strongSelf = self else { return }
            strongSelf.dataSource.updateSnapshot(for: recentPromosAnimeFeed.section, with: promos, animating: true)
        }.disposed(by: disposeBag)
    }
}

private extension Feed {
    // TODO: Is there even a way to filter those?
    func filterNoImagePromos(promos: [Promo]) {}
}

extension Feed: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard cellIsSelectable else { return }
        cellIsSelectable = false

        let cell = collectionView.cellForItem(at: indexPath)
        cell?.expand(lasting: 0.15, end: .reset, toScale: 1.05) { [weak self] in
            self?.cellIsSelectable = true
        }
    }
}
