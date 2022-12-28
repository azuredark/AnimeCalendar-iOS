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
//    weak var trailerComponent: TrailerCompatible?

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

        guard let collectionView = collectionView else { return }

        dataSource = DiffableDataSource(collectionView: collectionView) { collectionView, indexPath, item in
            let section = DetailFeedSection.allCases[indexPath.section]

            switch section {
                case .animeTrailer, .animeBasicInfo, .animeCharacters, .animeReviews:
                    guard let trailer = item as? Trailer else { return nil }
                    return collectionView.dequeueConfiguredReusableCell(using: trailerCell,
                                                                        for: indexPath,
                                                                        item: trailer)
            }
        }
    }
}

private extension DetailFeedDataSource {
    func configureCollection() {
        // MARK: Cells
        // Trailer Cell
        collectionView?.register(TrailerCell.self, forCellWithReuseIdentifier: TrailerCell.reuseIdentifier)
    }
}

extension DetailFeedDataSource: FeedDataSourceable {
    func updateSnapshot<T: CaseIterable>(for section: T, with items: [AnyHashable], animating: Bool) {
        guard let section = section as? DetailFeedSection else { return }

        // Append section only if it doesn't exist already
        if currentSnapshot.indexOfSection(section) == nil {
            currentSnapshot.appendSections([section])
        }
        currentSnapshot.appendItems(items, toSection: section)
        dataSource?.apply(currentSnapshot, animatingDifferences: animating)
    }

    func getItem<T>(at indexPath: IndexPath) -> T? where T: Hashable {
        return nil
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
            .filter { !$0.trailer.youtubeId.isEmpty }
            .drive(onNext: { [weak self] anime in
                guard let self = self else { return }
                let id = anime.trailer.youtubeId
                self.trailerComponent.loadTrailer(withId: id)
                print("senku [DEBUG] \(String(describing: type(of: self))) - RX PLAY ANIME")
            }).disposed(by: disposeBag)
    }

    func bindTrailer() {
        presenter?.didFinishLoadingAnimeAndTrailer
            .drive { [weak self] anime, _ in
                guard let self = self else { return }
                print("senku [DEBUG] \(String(describing: type(of: self))) - RX DID FINISH LOADING TRAILER")
                self.updateSnapshot(for: DetailFeedSection.animeTrailer, with: [anime.trailer], animating: true)
            }.disposed(by: disposeBag)
    }
}

enum DetailFeedSection: String, CaseIterable {
    case animeTrailer
    case animeBasicInfo
    case animeCharacters
    case animeReviews
}
