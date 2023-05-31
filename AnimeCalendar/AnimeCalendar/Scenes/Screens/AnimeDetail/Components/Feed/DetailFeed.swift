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
    // These have to be created for EACH KIND (If there is a different HeaderView, then add a new one)
    static let basicInfoHeaderKind: String = "BASIC_INFO_HEADER_KIND"
    static let feedHeaderKind: String      = "FEED_HEADER_KIND"

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

    func getTrailerComponent() -> TrailerCompatible? {
        return presenter?.playerComponent
    }
}

// MARK: - Sections
private extension DetailFeed {
    func getLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] (sectionIndex, _) in
            guard let self = self else { fatalError("No DetailFeed reference while generating collection layout") }
            guard let content = self.dataSource.getDataSource()?.itemIdentifier(for: IndexPath(row: 0, section: sectionIndex)) as? Content else {
                return nil
            }

            switch content.detailFeedSection {
                case .animeTrailer:
                    return self.getTrailerSection()
                case .animeBasicInfo:
                    return self.getBasicInfoSection()
                case .animeCharacters:
                    return self.getCharactersSection()
                case .animeReviews:
                    return self.getReviewsSection()
                case .animeRecommendations:
                    return self.getRecommendedSection()
                // Loader
                case .spinner:
                    return self.getSpinnerSection()
                case .unknown: return nil
            }
        }

        return layout
    }

    /// Get the **correct** section for its corresponding layout.
    ///
    /// **Warning**: This is needed as the **TrailerCell** will appear afterwards and take first spot. Until that happens, the **sectionIndex** will be 0 and point to the **.animeTrailer** enum which is wrong as the first cell before **Trailer** will always be **BasicInfo**.
    func getSection(from sectionIndex: Int) -> DetailFeedSection {
        var section = DetailFeedSection.allCases[sectionIndex]
        // If there is 1 section and it's wrongly pointing to .animeTrailer, manual-set it to animeBasicInfo.
        if self.containerCollection.numberOfSections == 1, section == .animeTrailer {
            section = .animeBasicInfo
        }
        return section
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
    /// Layout for Basic Info.
    ///
    /// **Important**: The height dimension *estimated = 50* is used to indicate the height depends on its content. It works by having its only cell have the full size of the **Item & group**
    func getBasicInfoSection() -> NSCollectionLayoutSection {
        // Item
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                              heightDimension: .estimated(50))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        // Group
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                               heightDimension: .estimated(50))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        // Header
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                heightDimension: .estimated(70))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize,
                                                                 elementKind: Self.basicInfoHeaderKind,
                                                                 alignment: .top)

        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .none
        section.boundarySupplementaryItems = [header]
        section.contentInsets = .init(top: 5.0, leading: 0, bottom: 0, trailing: 0)

        return section
    }

    /// # Characters Section
    func getCharactersSection() -> NSCollectionLayoutSection? {
        // Item
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                              heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        // Group
        let aspectRatio: CGFloat = 16/9
        let widthRatio: CGFloat  = 0.25
        let heightRatio: CGFloat = widthRatio * aspectRatio
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(widthRatio),
                                               heightDimension: .fractionalWidth(heightRatio))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        // Header
        let headerWidth: CGFloat = UIScreen.main.bounds.size.width
        let headerSize = NSCollectionLayoutSize(widthDimension: .absolute(headerWidth),
                                                heightDimension: .estimated(70))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize,
                                                                 elementKind: Self.feedHeaderKind,
                                                                 alignment: .top)

        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.boundarySupplementaryItems = [header]
        section.contentInsets = .init(top: 0, leading: 10, bottom: 8.0, trailing: 10)
        section.interGroupSpacing = 10.0

        return section
    }

    func getSpinnerSection() -> NSCollectionLayoutSection? {
        // Item
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                              heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        // Group
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                               heightDimension: .absolute(50.0))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        // Section
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .none // Prevent scrolling

        return section
    }

    /// # Reviews Section
    func getReviewsSection() -> NSCollectionLayoutSection? {
        // Item
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                              heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        // Group
        let height: CGFloat = 150.0
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.80),
                                               heightDimension: .absolute(height))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        // Header
        let headerWidth: CGFloat = UIScreen.main.bounds.size.width
        let headerSize = NSCollectionLayoutSize(widthDimension: .absolute(headerWidth),
                                                heightDimension: .estimated(70))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize,
                                                                 elementKind: Self.feedHeaderKind,
                                                                 alignment: .top)
        
        // Section
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        section.boundarySupplementaryItems = [header]
        section.contentInsets = .init(top: 0, leading: 10, bottom: 8.0, trailing: 10)
        section.interGroupSpacing = 10.0

        return section
    }
    
    func getRecommendedSection() -> NSCollectionLayoutSection? {
        // Item
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                              heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        // Group
        let aspectRatio: CGFloat = 16/9
        let widthRatio: CGFloat  = 0.20
        let titleHeight: CGFloat = 15.0 / UIScreen.main.bounds.size.height
        let heightRatio: CGFloat = (widthRatio * aspectRatio) + titleHeight
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(widthRatio),
                                               heightDimension: .fractionalWidth(heightRatio))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        // Header
        let headerWidth: CGFloat = UIScreen.main.bounds.size.width
        let headerSize = NSCollectionLayoutSize(widthDimension: .absolute(headerWidth),
                                                heightDimension: .estimated(70))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize,
                                                                 elementKind: Self.feedHeaderKind,
                                                                 alignment: .top)
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
        section.boundarySupplementaryItems = [header]
        section.contentInsets = .init(top: 0, leading: 10, bottom: 8.0, trailing: 10)
        section.interGroupSpacing = 10.0
        
        return section
    }
}
