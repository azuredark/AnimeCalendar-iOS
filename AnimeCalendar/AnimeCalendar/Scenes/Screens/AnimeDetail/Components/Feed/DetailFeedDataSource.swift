//
//  DetailFeedDataSource.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 27/12/22.
//

import UIKit
import RxSwift
import RxCocoa

final class DetailFeedDataSource {
    // MARK: Aliases
    typealias DiffableDataSource = UICollectionViewDiffableDataSource<DetailFeedSection, AnyHashable>
    typealias Snapshot = NSDiffableDataSourceSnapshot<DetailFeedSection, AnyHashable>

    // MARK: State
    /// # Presenter
    private weak var presenter: AnimeDetailPresentable?
    var trailerWasPresented: Bool = false

    /// # Components
    private(set) lazy var playerComponent: TrailerCompatible = {
        guard let player = presenter?.playerComponent else {
            let component = TrailerComponent.shared
            component.presenter = presenter
            return component
        }
        return player
    }()

    private let disposeBag = DisposeBag()

    private weak var collectionView: UICollectionView?
    private(set) var dataSource: DiffableDataSource?
    private(set) var currentSnapshot = Snapshot()

    // MARK: Initializers
    init(for collectionView: UICollectionView?, presenter: AnimeDetailPresentable?) {
        self.collectionView = collectionView
        self.presenter = presenter

        configureCollection()
        buildDataSource()
    }

    deinit {
        print("senku [DEBUG] \(String(describing: type(of: self))) - deinited")
    }
    
    // MARK: Methods
}

private extension DetailFeedDataSource {
    func buildDataSource() {
        let trailerCell = UICollectionView.CellRegistration<TrailerCell, Trailer> {
            [weak self] (cell, _, trailer) in
            guard let self = self else { return }
            cell.ds = self
            cell.trailer = trailer
            cell.trailerComponent = self.playerComponent
            cell.setup()
        }

        let basicInfoCell = UICollectionView.CellRegistration<BasicInfoCell, Anime> { cell, _, anime in
            cell.anime = anime
            cell.setup()
        }

        let characterCell = UICollectionView.CellRegistration<CharacterCell, CharacterInfo> { (cell, _, characterInfo) in
            cell.characterInfo = characterInfo
            cell.setup()
        }

        let reviewCell = UICollectionView.CellRegistration<ReviewCell, ReviewInfo> { (cell, _, reviewInfo) in
            cell.reviewInfo = reviewInfo
            cell.setup()
        }

        let recommendationCell = UICollectionView.CellRegistration<RecommendedCell, RecommendationInfo> {
            (cell, _, recommendationInfo) in
            cell.animeInfo = recommendationInfo
            cell.setup()
        }

        let loaderCell = UICollectionView.CellRegistration<ACSectionLoaderCell, ACContentLoader> { (cell, _, content) in
            let model = ACSectionLoaderModel(detailSection: content.detailFeedSection)
            cell.setup(with: model)
        }

        guard let collectionView else { return }

        // Dequeing cells.
        dataSource = DiffableDataSource(collectionView: collectionView) { collectionView, indexPath, item in
            guard let item = item as? Content else { return nil }

            // Loader
            if let data = item as? ACContentLoader {
                return loaderCell.cellProvider(collectionView, indexPath, data)
            }

            let section = item.detailFeedSection
            switch section {
                case .animeTrailer:
                    guard let trailer = item as? Trailer else { return nil }
                    return trailerCell.cellProvider(collectionView, indexPath, trailer)
                case .animeBasicInfo:
                    guard let anime = item as? Anime else { return nil }
                    return basicInfoCell.cellProvider(collectionView, indexPath, anime)
                case .animeCharacters:
                    guard let characterInfo = item as? CharacterInfo else { return nil }
                    return characterCell.cellProvider(collectionView, indexPath, characterInfo)
                case .animeReviews:
                    guard let reviewInfo = item as? ReviewInfo else { return nil }
                    return reviewCell.cellProvider(collectionView, indexPath, reviewInfo)
                case .animeRecommendations:
                    guard let recommendationInfo = item as? RecommendationInfo else { return nil }
                    return recommendationCell.cellProvider(collectionView, indexPath, recommendationInfo)
                default: return nil
            }
        }

        dataSource?.supplementaryViewProvider = { [weak self] (collection, kind, indexPath) -> UICollectionReusableView? in
            guard let self, let content = self.dataSource?.itemIdentifier(for: indexPath) as? Content else { return nil }

            if content.detailFeedSection == .animeBasicInfo, let anime = content as? Anime {
                let headerView = collection.dequeueReusableSupplementaryView(ofKind: kind,
                                                                             withReuseIdentifier: BasicInfoHeader.reuseIdentifier,
                                                                             for: indexPath) as? BasicInfoHeader
                headerView?.anime = anime
                headerView?.setup()

                return headerView
            }

            let headerView = collection.dequeueReusableSupplementaryView(ofKind: kind,
                                                                         withReuseIdentifier: DetailFeedHeader.reuseId,
                                                                         for: indexPath) as? DetailFeedHeader
            var model = FeedHeaderModel(text: content.detailFeedSection.rawValue)
            model.title.font = ACFont.bold.sectionTitle2
            headerView?.setup(with: model)
            return headerView
        }
    }
}

private extension DetailFeedDataSource {
    func configureCollection() {
        // MARK: Cells
        // ACSpinner Cell
        collectionView?.register(ACSectionLoaderCell.self, forCellWithReuseIdentifier: ACSectionLoaderCell.reuseIdentifier)

        // Trailer Cell
        collectionView?.register(TrailerCell.self, forCellWithReuseIdentifier: TrailerCell.reuseIdentifier)

        // Basic info. Cell
        collectionView?.register(BasicInfoCell.self, forCellWithReuseIdentifier: BasicInfoCell.reuseIdentifier)

        // Characters Cell
        collectionView?.register(CharacterCell.self, forCellWithReuseIdentifier: CharacterCell.reuseIdentifier)

        // Reviews Cell
        collectionView?.register(ReviewCell.self, forCellWithReuseIdentifier: ReviewCell.reuseIdentifier)

        // Recommended Cell
        collectionView?.register(RecommendedCell.self, forCellWithReuseIdentifier: RecommendedCell.reuseIdentifier)

        // MARK: Headers
        // Basic info. header (Anime title)
        collectionView?.register(BasicInfoHeader.self,
                                 forSupplementaryViewOfKind: DetailFeed.basicInfoHeaderKind,
                                 withReuseIdentifier: BasicInfoHeader.reuseIdentifier)

        // Feed Header.
        collectionView?.register(DetailFeedHeader.self,
                                 forSupplementaryViewOfKind: DetailFeed.feedHeaderKind,
                                 withReuseIdentifier: DetailFeedHeader.reuseId)

        collectionView?.dataSource = dataSource
    }
}

extension DetailFeedDataSource: FeedDataSourceable {
    #warning("Create methods x Model type (Anime, Promo, Trailer) instead of using Dynamic Dispatch (any Model)")
    func updateSnapshot<T: Hashable>(for section: DetailFeedSection,
                                     with items: [T],
                                     animating: Bool = true,
                                     before: DetailFeedSection? = nil,
                                     after: DetailFeedSection? = nil,
                                     deleteLoaders: Bool = false) {
        guard !items.isEmpty else { return }
        guard var currentSnapshot = dataSource?.snapshot() else { return }

        // Append section only if it doesn't exist already.
        if currentSnapshot.indexOfSection(section) == nil {
            // Insert before specific section if exists.
            if let before, sectionExists(before, in: currentSnapshot) {
                currentSnapshot.insertSections([section], beforeSection: before)
            } else if let after, sectionExists(after, in: currentSnapshot) {
                currentSnapshot.insertSections([section], afterSection: after)
            } else {
                // Append to the stack in order instead.
                currentSnapshot.appendSections([section])
            }
        }

        // Add items.
        currentSnapshot.appendItems(items, toSection: section)

        // Apply snapshot
        dataSource?.apply(currentSnapshot, animatingDifferences: animating)
    }

    func deleteSection(_ section: DetailFeedSection, animating: Bool = true) {
        guard var snapshot = dataSource?.snapshot() else { return }
        guard sectionExists(section, in: snapshot) else { return }

        // Delete section
        snapshot.deleteSections([section])

        // Apply snapshot
        dataSource?.apply(snapshot, animatingDifferences: animating)
    }

    func getDataSource() -> DiffableDataSource? {
        return dataSource
    }
}

private extension DetailFeedDataSource {
    func sectionExists(_ section: DetailFeedSection, in snapshot: Snapshot) -> Bool {
        return snapshot.indexOfSection(section) != nil
    }
}

// MARK: - Delegate
extension DetailFeedDataSource {
    func configureBindings() {
        bindAnime()
        bindTrailer()
        bindCharacters()
        bindReviews()
        bindRecommendations()

        sendLoaders()
    }

    /// Add loader sections to the collection view (Snapshot).
    ///
    /// - Important: This also defines the order in which the sections will be layed out
    func sendLoaders() {
        guard let presenter else { return }

        // Characters
        let charactersLoader = ACContentLoader(detailFeedSection: .animeCharacters)
        updateSnapshot(for: .loader(forSection: .animeCharacters),
                       with: [charactersLoader])

        let sectionsNotNeeded: [FeedSection] = [.animeUpcoming, .animePromos]
        guard ![presenter.animeFeedSection].includes(sectionsNotNeeded) else { return }

        // Recommendations
        let recommendationsLoader = ACContentLoader(detailFeedSection: .animeRecommendations)
        updateSnapshot(for: .loader(forSection: .animeRecommendations),
                       with: [recommendationsLoader])

        // Reviews
        let reviewsLoader = ACContentLoader(detailFeedSection: .animeReviews)
        updateSnapshot(for: .loader(forSection: .animeReviews),
                       with: [reviewsLoader])
    }

    func bindAnime() {
        guard let presenter = presenter else { return }

        // Basic Info
        presenter.anime
            .drive(onNext: { [weak self] (anime) in
                guard let self = self else { return }
                self.updateSnapshot(for: DetailFeedSection.animeBasicInfo,
                                    with: [anime],
                                    animating: true)
            }).disposed(by: disposeBag)

        // Request trailer.
        presenter.anime
            .drive(onNext: { [weak self] (anime) in
                guard let self else { return }
                guard let id = anime.trailer?.youtubeId else { return }
                self.presenter?.playerComponent?.queueVideo(withId: id)
                print("senku [DEBUG] \(String(describing: type(of: self))) - RX PLAY ANIME")
            }).disposed(by: disposeBag)
    }

    func bindTrailer() {
        guard let presenter = presenter else { return }

        // Wait for trailer finishing loading
        presenter.didFinishLoadingAnimeAndTrailer
            .drive { [weak self] (_, anime) in
                guard let self else { return }
                guard let trailer = anime.trailer else  { return }
                print("senku [DEBUG] \(String(describing: type(of: self))) - RX DID FINISH LOADING TRAILER")

                guard let dataSource, dataSource.snapshot().indexOfSection(.animeTrailer) == nil else { return }

                self.updateSnapshot(for: DetailFeedSection.animeTrailer,
                                    with: [trailer],
                                    animating: true,
                                    before: .animeBasicInfo)
            }.disposed(by: disposeBag)
    }

    func bindCharacters() {
        guard let presenter else { return }

        presenter.characters
            .drive(onNext: { [weak self] (characters) in
                guard let self = self else { return }
                print("senku [DEBUG] \(String(describing: type(of: self))) - RX DID FINISH LOADING CHARACTERS: \(characters.count)")
                self.updateSnapshot(for: DetailFeedSection.animeCharacters,
                                    with: characters,
                                    animating: true,
                                    after: .animeBasicInfo)
                self.deleteSection(.loader(forSection: .animeCharacters))
            }).disposed(by: disposeBag)
    }

    func bindReviews() {
        guard let presenter else { return }

        presenter.reviews
            .drive(onNext: { [weak self] (reviews) in
                guard let self else { return }
                Logger.log(.info, msg: "Review tags: \(reviews.flatMap { $0.tags }.map { $0.rawValue })", active: false)
                self.updateSnapshot(for: DetailFeedSection.animeReviews,
                                    with: reviews,
                                    animating: true,
                                    after: .loader(forSection: .animeReviews))
                self.deleteSection(.loader(forSection: .animeReviews))
            }).disposed(by: disposeBag)
    }

    func bindRecommendations() {
        guard let presenter else { return }
        presenter.recommendations
            .drive(onNext: { [weak self] (animesInfo) in
                guard let self else { return }
                Logger.log(.info, msg: "Recommended animes: \(animesInfo.map { $0.anime?.titleEng ?? "" })", active: false)
                self.updateSnapshot(for: DetailFeedSection.animeRecommendations,
                                    with: animesInfo,
                                    animating: true,
                                    after: .loader(forSection: .animeRecommendations))
                self.deleteSection(.loader(forSection: .animeRecommendations))
            }).disposed(by: disposeBag)
    }

    @available(*, deprecated, message: "Not currently working...")
    func startSpinners(_ charactersLoader: ACContentLoader, _ recommendationsLoader: ACContentLoader, _ reviewsLoader: ACContentLoader) {
        // Get all loader cells
        let indexPath1 = dataSource?.indexPath(for: charactersLoader)
        let indexPath2 = dataSource?.indexPath(for: recommendationsLoader)
        let indexPath3 = dataSource?.indexPath(for: reviewsLoader)

        let indexPaths = [indexPath1, indexPath2, indexPath3].compactMap { $0 }

        indexPaths.forEach { [weak self] (indexPath) in
            guard let self, let collectionView = self.collectionView else { return }
            guard let loaderCell = self.dataSource?.collectionView(collectionView, cellForItemAt: indexPath) as? ACSectionLoaderCell else { return }
//            loaderCell.startSpinning()
            loaderCell.contentView.layoutIfNeeded()
        }
    }
}

indirect enum DetailFeedSection: Hashable {
    case animeTrailer
    case animeBasicInfo
    case animeCharacters      // = "Characters"
    case animeReviews         // = "Reviews"
    case animeRecommendations // = "Recommended"
    case loader(forSection: DetailFeedSection? = nil)
    case unknown

    init(_ index: Int) {
        switch index {
            case 0: self = .animeTrailer
            case 1: self = .animeBasicInfo
            case 2: self = .animeCharacters
            case 3: self = .animeReviews
            case 4: self = .animeRecommendations
            default: self = .unknown
        }
    }

    static func == (lhs: DetailFeedSection, rhs: DetailFeedSection) -> Bool {
        switch (lhs, rhs) {
            case (.animeTrailer, .animeTrailer): return true
            case (.animeBasicInfo, .animeBasicInfo): return true
            case (.animeCharacters, .animeCharacters): return true
            case (.animeReviews, .animeReviews): return true
            case (.animeRecommendations, .animeRecommendations): return true
            case (.unknown, .unknown): return true
            case (.loader(let section1), .loader(let section2)) where section1 == section2: return true
            default: return false
        }
    }

    var rawValue: String {
        switch self {
            case .animeTrailer: return "Trailer"
            case .animeBasicInfo: return "Basic info."
            case .animeCharacters: return "Characters"
            case .animeReviews: return "Reviews"
            case .animeRecommendations: return "Recommended"
            default: return ""
        }
    }
}
