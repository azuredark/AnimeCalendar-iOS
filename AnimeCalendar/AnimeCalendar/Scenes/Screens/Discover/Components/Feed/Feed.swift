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
        self.presenter?.feedView = self

        containerCollection.delegate = self
        configureBindings()
    }

    // MARK: Methods
    func getCollection() -> UICollectionView {
        return containerCollection
    }

    func getDataSource() -> FeedDataSource {
        return dataSource
    }
}

private extension Feed {
    func getLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] sectionIndex, _ in
            guard let strongSelf = self else { fatalError("No Feed reference while generating collection layout") }
            guard let item = strongSelf.dataSource.getItem(at: IndexPath(item: 0, section: sectionIndex)) as? (any ModelSectionable) else { return nil }
            switch item.feedSection {
                case .animeSeason:
                    return strongSelf.getAnimeSeasonSection()
                case .animePromos:
                    return strongSelf.getAnimePromosSection()
                case .animeTop:
                    return strongSelf.getAnimeTopSection()
                case .unknown: return nil
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

    // TODO: Clean up ...
    func bindFeed() {
        guard let discoverFeed = presenter?.feed else { return }

        // Season Anime
        let seasonAnimeFeed = discoverFeed.seasonAnime
        seasonAnimeFeed.observable
            .asDriver()
            .filter { !$0.isEmpty }
            .drive { [weak self] (animes) in
                guard let self else { return }
                let loader = animes.first(where: \.isLoading); let hasLoader = (loader != nil)
                self.dataSource.updateSnapshot(for: seasonAnimeFeed.section, with: animes, animating: true, deleteLoaders: !hasLoader)
            }.disposed(by: disposeBag)

        // Anime Promos
        let recentPromosAnimeFeed = discoverFeed.recentPromosAnime
        recentPromosAnimeFeed.observable
            .asDriver()
            .filter { !$0.isEmpty }
            .drive { [weak self] (promos) in
                guard let self else { return }
                let loader = promos.first(where: \.isLoading); let hasLoader = (loader != nil)
                self.dataSource.updateSnapshot(for: recentPromosAnimeFeed.section, with: promos, animating: true, deleteLoaders: !hasLoader)

            }.disposed(by: disposeBag)

        // Top Anime
        let topAnimeFeed = discoverFeed.topAnime
        topAnimeFeed.observable
            .asDriver()
            .filter { !$0.isEmpty }
            .drive { [weak self] (animes) in
                guard let self else { return }
                let loader = animes.first(where: \.isLoading); let hasLoader = (loader != nil)
                self.dataSource.updateSnapshot(for: topAnimeFeed.section, with: animes, animating: true, deleteLoaders: !hasLoader)
            }.disposed(by: disposeBag)
    }
}

extension Feed: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath), (cell as? ACLoaderCell) == nil else { return }

        guard cellIsSelectable else { return }
        cellIsSelectable = false

        cell.expand(durationInSeconds: 0.15, end: .reset, toScale: 0.95) { [weak self] in
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
