//
//  DetailFeed.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 27/12/22.
//

import RxSwift
import RxCocoa

final class DetailFeed: NSObject {
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

    /// # Presenter
    private weak var presenter: AnimeDetailPresentable?

    /// # DataSource
    private lazy var dataSource: DetailFeedDataSource = {
        DetailFeedDataSource(for: containerCollection, presenter: presenter)
    }()

    private lazy var disposeBag = DisposeBag()

    // MARK: Initializers
    init(presenter: AnimeDetailPresentable?) {
        super.init()
        self.presenter = presenter
        dataSource.configureBindings()
    }

    deinit {
        print("senku [DEBUG] \(String(describing: type(of: self))) - deinited")
    }
}

// MARK: - Delegate
extension DetailFeed {
    func getCollection() -> UICollectionView {
        return containerCollection
    }
}

// MARK: - Sections
private extension DetailFeed {
    func getLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] sectionIndex, _ in
            guard let self = self else { fatalError("No DetailFeed reference while generating collection layout") }

            let section = DetailFeedSection.allCases[sectionIndex]
            switch section {
                case .animeTrailer, .animeCharacters, .animeReviews:
                    return self.getTrailerSection()
                case .animeBasicInfo:
                    return self.getBasicInfoSection()
            }
        }

        return layout
    }

    /// #  Trailer Section
    func getTrailerSection() -> NSCollectionLayoutSection {
        // Item
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                              heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        // Group
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                               heightDimension: .fractionalHeight(6 / 19))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        // Section
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .none // Prevent scrolling

        return section
    }

    /// #  Basic Info. Section
    func getBasicInfoSection() -> NSCollectionLayoutSection {
        // Item
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                              heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        // Group
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                               heightDimension: .absolute(200.0))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        
        return section
    }

    /// # Characters Section
    func getCharactersSection() -> NSCollectionLayoutSection? {
        return nil
    }

    /// # Reviews Section
    func getReviewsSection() -> NSCollectionLayoutSection? {
        return nil
    }
}
