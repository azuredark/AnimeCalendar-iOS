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
                case .animeSeason:
                    return strongSelf.getAnimeSeasonSection()
                case .animePromos:
                    return strongSelf.getAnimePromosSection()
                case .animeTop:
                    return strongSelf.getAnimeTopSection()
            }
        }
        return layout
    }

    /// 1 Group vertical fit 1 item,  scrolling horizontally
    func getAnimeSeasonSection() -> NSCollectionLayoutSection {
        // Item
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        // Group
        let groupHeight: CGFloat = 250.0
        let groupWidth: CGFloat = groupHeight / 1.66 // 16:9
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(groupWidth),
                                               heightDimension: .absolute(groupHeight))
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
        section.interGroupSpacing = 15.0

        return section
    }

    /// 1 Group vertical fit 1 item,  scrolling horizontally
    func getAnimePromosSection() -> NSCollectionLayoutSection {
        // Item
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        // Group
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.65),
                                               heightDimension: .fractionalWidth(1 / 3))
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
        section.contentInsets = .init(top: 0, leading: 20.0, bottom: 15.0, trailing: 20.0)
        section.interGroupSpacing = 30.0

        return section
    }

    /// 1 Group vertical fit 2 items, scrolling horizontally
    func getAnimeTopSection() -> NSCollectionLayoutSection {
        // Item
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .absolute(100.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        // Group
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.76),
                                               heightDimension: .absolute(216.0))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        group.interItemSpacing = .fixed(16.0)

        // Header
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                heightDimension: .estimated(44))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize,
                                                                 elementKind: Self.sectionHeaderKind,
                                                                 alignment: .top)

        // Section
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
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
        seasonAnimeFeed.driver.drive { [weak self] (animes) in
            guard let strongSelf = self else { return }
            strongSelf.dataSource.updateSnapshot(for: seasonAnimeFeed.section, with: animes, animating: true)
        }.disposed(by: disposeBag)

        let recentPromosAnimeFeed = discoverFeed.recentPromosAnime
        recentPromosAnimeFeed.driver.drive { [weak self] (promos) in
            guard let strongSelf = self else { return }
            strongSelf.dataSource.updateSnapshot(for: recentPromosAnimeFeed.section, with: promos, animating: true)
        }.disposed(by: disposeBag)

        let topAnimeFeed = discoverFeed.topAnime
        topAnimeFeed.driver.drive { [weak self] (animes) in
            guard let strongSelf = self else { return }
            strongSelf.dataSource.updateSnapshot(for: topAnimeFeed.section, with: animes, animating: true)
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
        cell?.expand(durationInSeconds: 0.15, end: .reset, toScale: 0.95) { [weak self] in
            self?.cellIsSelectable = true
        }

        // Get the selected item (Anime or Promo) & present it.
        if var anime: Anime = dataSource.getItem(at: indexPath) {
            let image: UIImage? = (cell as? FeedCell)?.getCoverImage() ?? UIImage(named: "new-anime-item-spyxfamily")
            anime.imageType.coverImage = image
            presenter?.handle(action: .transition(to: .animeDetailScreen(anime: anime)))
        }
        #warning("Make it generic to work for Promos and other further types aswell.")
    }
}
