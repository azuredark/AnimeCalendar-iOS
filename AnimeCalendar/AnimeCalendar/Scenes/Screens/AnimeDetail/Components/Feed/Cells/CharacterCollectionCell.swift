//
//  CharacterCell.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 27/12/22.
//

import UIKit
import Nuke

final class CharacterCollectionCell: UICollectionViewCell, FeedCell {
    // MARK: State
    static var reuseIdentifier: String = "CHARACTER_CONTAINER_CELL_REUSE_ID"
    var charactersData: CharacterData?
    private lazy var preheater = ImagePrefetcher(pipeline: ImagePipeline.shared)

    private(set) lazy var collection: ACCollection<CharacterSection, CharacterInfo> = {
        let _collection = ACCollection<CharacterSection, CharacterInfo>()
        _collection.layoutDelegate = self
        _collection.dataSourceDelegate = self

        let collectionView = _collection.getCollection()
        collectionView.alwaysBounceVertical = false
        collectionView.prefetchDataSource = self

        contentView.addSubview(_collection.getCollection())
        return _collection
    }()

    /// # Cell Registrations
    typealias CharacterCellRegistration = UICollectionView.CellRegistration<CharacterCell, CharacterInfo>
    private let characterCell = CharacterCellRegistration { (cell, _, characterInfo) in
        cell.characterInfo = characterInfo
        cell.setup()
    }

    // MARK: Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        layoutUI()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
    }

    // MARK: Methods
    func setup() {
        collection.setup()
    }

    func updateSnapshot() {
        collection.updateSnapshot { [weak self] in
            guard let self = self else { return (CharacterSection.characters, nil) }
            return (CharacterSection.characters, self.charactersData?.data)
        }
    }
}

private extension CharacterCollectionCell {
    func layoutUI() {
        backgroundColor = .clear

        let collectionView = collection.getCollection()
        let yInset: CGFloat = 5.0
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: contentView.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -yInset)
        ])
    }
}

extension CharacterCollectionCell: ACColllectionLayoutable {
    func getSection(_ sectionIndex: Int, _ env: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? {
        // Actual dimensions
        let cellHeight: CGFloat = 200.0
        let cellWidth: CGFloat = cellHeight * 9 / 16

        // Item
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .absolute(cellHeight))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        // Groups
        let verticalGroupSize = NSCollectionLayoutSize(widthDimension: .absolute(cellWidth),
                                                       heightDimension: .fractionalHeight(1.0))
        let verticalGroup = NSCollectionLayoutGroup.vertical(layoutSize: verticalGroupSize, subitems: [item])
        verticalGroup.interItemSpacing = .fixed(10.0)

        let outerGroupSize = NSCollectionLayoutSize(widthDimension: .absolute((cellWidth * 2) + 10.0),
                                                    heightDimension: .absolute((cellHeight * 2) + 10.0))
        let outerGroup = NSCollectionLayoutGroup.horizontal(layoutSize: outerGroupSize,
                                                            subitems: [verticalGroup, verticalGroup])
        outerGroup.interItemSpacing = .fixed(10.0)

        // Header
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                heightDimension: .absolute(35))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize,
                                                                 elementKind: CharacterColletionHeader.sectionHeaderKind,
                                                                 alignment: .top)

        // Section
        let section = NSCollectionLayoutSection(group: outerGroup)
        section.orthogonalScrollingBehavior = .continuous
        section.boundarySupplementaryItems = [header]
        section.contentInsets = .init(top: 0, leading: 15, bottom: 0, trailing: 0)
        section.interGroupSpacing = 10.0

        return section
    }
}

extension CharacterCollectionCell: ACCollectionDataSourceable {
    func registerCells() {
        collection.getCollection().register(CharacterCell.self, forCellWithReuseIdentifier: CharacterCell.reuseIdentifier)
    }

    func registerHeaders() {
        collection.getCollection().register(CharacterColletionHeader.self,
                                            forSupplementaryViewOfKind: CharacterColletionHeader.sectionHeaderKind,
                                            withReuseIdentifier: CharacterColletionHeader.reuseIdentifier)
    }

    func provideCell<T: Hashable>(_ collection: UICollectionView, _ indexPath: IndexPath, _ item: T) -> UICollectionViewCell? {
        guard let characterInfo = item as? CharacterInfo else { return nil }
        return characterCell.cellProvider(collection, indexPath, characterInfo)
    }

    func provideHeader(_ collection: UICollectionView, _ indexPath: IndexPath, _ kind: String) -> UICollectionReusableView? {
        let headerView = collection.dequeueReusableSupplementaryView(ofKind: kind,
                                                                     withReuseIdentifier: CharacterColletionHeader.reuseIdentifier,
                                                                     for: indexPath) as? CharacterColletionHeader
        headerView?.setup()
        return headerView
    }
}

private extension CharacterCollectionCell {
    func getImagRequests(indexPaths: [IndexPath]) -> [Nuke.ImageRequest] {
        guard let ds = collection.getDataSource() else { return [] }

        let imagePaths = indexPaths.compactMap { indexPath in
            ds.itemIdentifier(for: indexPath)?.character.imageType?.jpgImage.attemptToGetImageByResolution(.large)
        }

        let urls = imagePaths.compactMap(URL.init)
        let requests = urls.map { Nuke.ImageRequest(url: $0) }

        return requests
    }
}

extension CharacterCollectionCell: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        Task {
            let requests = getImagRequests(indexPaths: indexPaths)
            preheater.startPrefetching(with: requests)
        }
    }

    func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
        Task {
            let requests = getImagRequests(indexPaths: indexPaths)
            preheater.stopPrefetching(with: requests)
        }
    }
}

enum CharacterSection {
    case characters
}
