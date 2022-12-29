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
    private typealias DiffableDataSource = UICollectionViewDiffableDataSource<DetailFeedSection, AnyHashable>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<DetailFeedSection, AnyHashable>

    // MARK: State
    /// # Presenter
    private weak var presenter: AnimeDetailPresentable?

    /// # Components
    private(set) lazy var trailerComponent: TrailerCompatible = {
        let trailer = TrailerComponent(presenter: presenter)
        return trailer
    }()

    private let disposeBag = DisposeBag()

    private weak var collectionView: UICollectionView?
    private var dataSource: DiffableDataSource?
    private var currentSnapshot = Snapshot()

    // MARK: Initializers
    init(for collectionView: UICollectionView?, presenter: AnimeDetailPresentable?) {
        self.collectionView = collectionView
        self.presenter = presenter

        print("senku [DEBUG] \(String(describing: type(of: self))) - PReSENTER?: \(self.presenter != nil)")
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
            [weak self] cell, _, trailer in
            cell.trailerComponent = self?.trailerComponent
            cell.trailer = trailer
            cell.setup()
        }

        let basicInfoCell = UICollectionView.CellRegistration<BasicInfoCell, Anime> { cell, _, anime in
            cell.anime = anime
            cell.setup()
        }

        guard let collectionView = collectionView else { return }

        dataSource = DiffableDataSource(collectionView: collectionView) { collectionView, indexPath, item in
            guard let item = item as? (any ModelSectionable) else { return nil }
            let section = item.detailFeedSection
//            let section = DetailFeedSection.allCases[indexPath.section]
            switch section {
                case .animeTrailer, .animeCharacters, .animeReviews:
                    guard let trailer = item as? Trailer else { return nil }
                    return collectionView.dequeueConfiguredReusableCell(using: trailerCell,
                                                                        for: indexPath,
                                                                        item: trailer)
                case .animeBasicInfo:
                    guard let anime = item as? Anime else { return nil }
                    return collectionView.dequeueConfiguredReusableCell(using: basicInfoCell,
                                                                        for: indexPath,
                                                                        item: anime)
            }
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
        print("senku [DEBUG] \(String(describing: type(of: self))) - CELLS REGISTERED")
    }
}

extension DetailFeedDataSource: FeedDataSourceable {
    func updateSnapshot<T: CaseIterable, O: Hashable>(for section: T, with items: [O], animating: Bool, before: T? = nil, after: T? = nil) {
        guard let section = section as? DetailFeedSection else { return }
        let finalItems = setModelSection(for: section, with: items)

        // Append section only if it doesn't exist already
        if currentSnapshot.indexOfSection(section) == nil {
            if let before = before as? DetailFeedSection {
                currentSnapshot.insertSections([section], beforeSection: before)
            } else {
                currentSnapshot.appendSections([section])
            }
        }
        currentSnapshot.appendItems(finalItems, toSection: section)
        dataSource?.apply(currentSnapshot, animatingDifferences: animating)
    }

    func getItem<T: Hashable>(at indexPath: IndexPath) -> T? {
        return nil
    }

    func setModelSection<T: CaseIterable, O: Hashable>(for section: T, with items: [O]) -> [AnyHashable] {
        guard let section = section as? DetailFeedSection else { return [] }
        var items = items.compactMap { $0 as? (any ModelSectionable) }
        items.indices.forEach { items[$0].detailFeedSection = section }
        guard let finalItems = items as? [AnyHashable] else { return [] }
        return finalItems
    }
}

// MARK: - Delegate
extension DetailFeedDataSource {
    func configureBindings() {
        bindTrailer()
        bindAnime()
    }

    func bindAnime() {
        presenter?.anime
            .drive(onNext: { [weak self] anime in
                guard let self = self else { return }
                self.updateSnapshot(for: DetailFeedSection.animeBasicInfo, with: [anime], animating: true)
            }).disposed(by: disposeBag)

        presenter?.anime
            .filter { !$0.trailer.youtubeId.isEmpty }
            .drive(onNext: { [weak self] anime in
                guard let self = self else { return }
                let id = anime.trailer.youtubeId
                self.trailerComponent.loadTrailer(withId: id)
                print("senku [DEBUG] \(String(describing: type(of: self))) - RX PLAY ANIME")
            }).disposed(by: disposeBag)
    }

    func bindTrailer() {
        guard let presenter = presenter else { return }

        presenter.didFinishLoadingAnimeAndTrailer
            .drive { [weak self] anime, _ in
                guard let self = self else { return }
                print("senku [DEBUG] \(String(describing: type(of: self))) - RX DID FINISH LOADING TRAILER")
                self.updateSnapshot(for: DetailFeedSection.animeTrailer, with: [anime.trailer], animating: true, before: .animeBasicInfo)
            }.disposed(by: disposeBag)

//        Observable.combineLatest(presenter.didFinishLoadingAnimeAndTrailer.asObservable(),
//                                 presenter.anime.asObservable())
//            .asDriver(onErrorJustReturn: ((Anime(), false), Anime()))
//            .drive { [weak self] didLoad, anime in
//                guard let self = self else { return }
//
//            }.disposed(by: disposeBag)
    }
}

enum DetailFeedSection: String, CaseIterable {
    case animeTrailer
    case animeBasicInfo
    case animeCharacters
    case animeReviews
}
