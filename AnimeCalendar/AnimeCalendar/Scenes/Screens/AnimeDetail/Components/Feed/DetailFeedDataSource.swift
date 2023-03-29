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
            let component = TrailerComponent()
            component.presenter = presenter
            return component
        }
        return player
    }()

    private let disposeBag = DisposeBag()

    private weak var collectionView: UICollectionView?
    private var dataSource: DiffableDataSource?
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

        let characterCell = UICollectionView.CellRegistration<CharacterCollectionCell, CharacterData> { cell, _, charactersData in
            cell.charactersData = charactersData
            cell.setup()
            cell.updateSnapshot()
        }

        let spinnerCell = UICollectionView.CellRegistration<SpinnerCell, AnyHashable> { cell, _, _ in
            cell.setup()
        }

        guard let collectionView else { return }

        // Dequeing cells.
        dataSource = DiffableDataSource(collectionView: collectionView) { collectionView, indexPath, item in
            guard let item = item as? (any ModelSectionable) else { return nil }

            let section = item.detailFeedSection
            switch section {
                case .animeTrailer:
                    guard let trailer = item as? Trailer else { return nil }
                    return trailerCell.cellProvider(collectionView, indexPath, trailer)
                case .animeBasicInfo:
                    guard let anime = item as? Anime else { return nil }
                    return basicInfoCell.cellProvider(collectionView, indexPath, anime)
                case .animeCharacters:
                    guard let charactersData = item as? CharacterData else { return nil }
                    return characterCell.cellProvider(collectionView, indexPath, charactersData)
                case .animeReviews: return nil
                case .spinner:
                    guard let data = item as? SpinnerModel else { return nil }
                    return spinnerCell.cellProvider(collectionView, indexPath, data)
                case .unknown: return nil
            }
        }

        dataSource?.supplementaryViewProvider = {
            [weak self] (collection, kind, indexPath) -> UICollectionReusableView? in
            guard let self = self else { return nil }
            let headerView = collection.dequeueReusableSupplementaryView(ofKind: kind,
                                                                         withReuseIdentifier: BasicInfoHeader.reuseIdentifier,
                                                                         for: indexPath) as? BasicInfoHeader
            guard let anime = self.dataSource?.itemIdentifier(for: indexPath) as? Anime else { return nil }
            headerView?.anime = anime
            headerView?.setup()

            return headerView
        }
    }
}

private extension DetailFeedDataSource {
    func configureCollection() {
        // MARK: Cells
        // Trailer Cell
        collectionView?.register(TrailerCell.self, forCellWithReuseIdentifier: TrailerCell.reuseIdentifier)

        // Basic info. Cell
        collectionView?.register(BasicInfoCell.self, forCellWithReuseIdentifier: BasicInfoCell.reuseIdentifier)

        // Characters Cell
        collectionView?.register(CharacterCollectionCell.self, forCellWithReuseIdentifier: CharacterCollectionCell.reuseIdentifier)

        // MARK: Headers
        // Basic info. header (Anime title)
        collectionView?.register(BasicInfoHeader.self,
                                 forSupplementaryViewOfKind: DetailFeed.sectionHeaderKind,
                                 withReuseIdentifier: BasicInfoHeader.reuseIdentifier)

        collectionView?.dataSource = dataSource
    }
}

extension DetailFeedDataSource: FeedDataSourceable {
    #warning("Create methods x Model type (Anime, Promo, Trailer) instead of using Dynamic Dispatch (any Model)")
    func updateSnapshot<T: CaseIterable, O: Hashable>(for section: T, with items: [O], animating: Bool, before: T? = nil, after: T? = nil, deleteLoaders: Bool = false) {
        guard let section = section as? DetailFeedSection else { return }
        let finalItems = setModelSection(for: section, with: items)
        if sectionExists(section: section) { return }

        // Append section only if it doesn't exist already.
        if !sectionExists(section: section) {
            // Insert before specific section if exists.
            if let before = before as? DetailFeedSection, sectionExists(section: before) {
                currentSnapshot.insertSections([section], beforeSection: before)
            } else if let after = after as? DetailFeedSection, sectionExists(section: after) {
                currentSnapshot.insertSections([section], afterSection: after)
            } else {
                // Append to the stack in order instead.
                currentSnapshot.appendSections([section])
            }
        }
        
        currentSnapshot.appendItems(finalItems, toSection: section)
        dataSource?.apply(currentSnapshot, animatingDifferences: animating)
        
        // Removes the spinner after **CharacterSection & AnimeBasicInfo** has been loaded.
        removeSpinnerIfNeeded()
    }

    func updateSnapshot(completion: (_ snapshot: Snapshot) -> Snapshot) {
        let newSnapshot = completion(currentSnapshot)
        dataSource?.apply(newSnapshot, animatingDifferences: true)
    }

    func getItem<T: Hashable>(at indexPath: IndexPath) -> T? {
        return nil
    }

    func getDataSource() -> DiffableDataSource? {
        return dataSource
    }

    func setModelSection<T: CaseIterable, O: Hashable>(for section: T, with items: [O]) -> [AnyHashable] {
        guard let section = section as? DetailFeedSection else { return [] }

        var items = items.compactMap { $0 as? (any ModelSectionable) }
        items.indices.forEach { items[$0].detailFeedSection = section }

        guard let finalItems = items as? [AnyHashable] else { return [] }

        return finalItems
    }

    func removeSpinnerIfNeeded() {
        guard sectionExists(section: .spinner) else { return }
        if sectionExists(section: .animeBasicInfo),
           sectionExists(section: .animeCharacters) {
            Task { @MainActor in
                currentSnapshot.deleteSections([.spinner])
                dataSource?.apply(currentSnapshot, animatingDifferences: true)
            }
        }
    }
}

private extension DetailFeedDataSource {
    func sectionExists(section: DetailFeedSection) -> Bool {
        return currentSnapshot.indexOfSection(section) != nil
    }
}

// MARK: - Delegate
extension DetailFeedDataSource {
    func configureBindings() {
        bindAnime()
        loadSpinner()
        bindTrailer()
        bindCharacters()
    }

    func loadSpinner() {
        updateSnapshot(for: DetailFeedSection.spinner,
                       with: [SpinnerModel(isLoading: true)],
                       animating: true,
                       after: DetailFeedSection.animeBasicInfo)
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
                guard let self = self else { return }
                let id = anime.trailer.youtubeId
                self.presenter?.playerComponent?.queueVideo(withId: id)
                print("senku [DEBUG] \(String(describing: type(of: self))) - RX PLAY ANIME")
            }).disposed(by: disposeBag)
    }

    func bindTrailer() {
        guard let presenter = presenter else { return }

        // Wait for trailer finishing loading
        presenter.didFinishLoadingAnimeAndTrailer
            .filter { $1 }
            .drive { [weak self] (anime, _) in
                guard let self = self else { return }
                print("senku [DEBUG] \(String(describing: type(of: self))) - RX DID FINISH LOADING TRAILER")
                self.updateSnapshot(for: DetailFeedSection.animeTrailer,
                                    with: [anime.trailer],
                                    animating: true,
                                    before: .animeBasicInfo)
            }.disposed(by: disposeBag)
    }

    func bindCharacters() {
        guard let presenter = presenter else { return }

        presenter.characters
            .debounce(.milliseconds(500))
            .drive(onNext: { [weak self] (characetersData) in
                guard let self = self else { return }
                print("senku [DEBUG] \(String(describing: type(of: self))) - RX DID FINISH LOADING CHARACTERS: \(characetersData.data.count)")
                self.updateSnapshot(for: DetailFeedSection.animeCharacters,
                                    with: [characetersData],
                                    animating: true,
                                    after: .animeBasicInfo)
            }).disposed(by: disposeBag)
    }
}

enum DetailFeedSection: String, CaseIterable {
    case animeTrailer
    case animeBasicInfo
    case animeCharacters
    case animeReviews
    case spinner
    case unknown

    init(_ index: Int) {
        switch index {
            case 0: self = .animeTrailer
            case 1: self = .animeBasicInfo
            case 2: self = .animeCharacters
            case 3: self = .animeReviews
            case 4: self = .spinner
            default: self = .unknown
        }
    }
}
