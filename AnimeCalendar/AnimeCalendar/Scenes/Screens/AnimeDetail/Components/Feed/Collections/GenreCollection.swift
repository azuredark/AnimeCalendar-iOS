//
//  GenreCollection.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 7/01/23.
//

import UIKit

enum GenreSection: Hashable {
    case genre
}

final class GenreCollection {
    // MARK: State
    var genres: [AnimeGenre]?

    private(set) lazy var collection: ACCollection<GenreSection, AnimeGenre> = {
        let _collection = ACCollection<GenreSection, AnimeGenre>()
        return _collection
    }()

    /// # Cell Registrations
    typealias GenreCellRegistration = UICollectionView.CellRegistration<GenreCell, AnimeGenre>
    private let genreCell = GenreCellRegistration { (cell, _, genre) in
        cell.genre = genre
        cell.setup()
    }

    // MARK: Initializers
    init() {
        collection.layoutDelegate = self
        collection.dataSourceDelegate = self
    }

    // MARK: Methods
    func setup() {
        collection.setup()
    }

    func reset() {
        collection.reset()
    }

    func getCollectionView() -> UICollectionView {
        collection.getCollection()
    }

    func updateSnapshot() {
        collection.updateSnapshot { [weak self] in
            guard let self = self else { return (GenreSection.genre, nil) }
            return (GenreSection.genre, self.genres)
        }
    }
}

extension GenreCollection: ACColllectionLayoutable {
    func getSection(_ sectionIndex: Int, _ env: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? {
        // Item
        let itemSize = NSCollectionLayoutSize(widthDimension: .estimated(50.0),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        // Group
        let groupSize = NSCollectionLayoutSize(widthDimension: .estimated(50.0),
                                               heightDimension: .fractionalHeight(1.0))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        // Section
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.interGroupSpacing = 8.0

        return section
    }
}

extension GenreCollection: ACCollectionDataSourceable {
    func registerCells() {
        collection.getCollection().register(GenreCell.self,
                                               forCellWithReuseIdentifier: GenreCell.reuseIdentifier)
    }

    func provideCell<T: Hashable>(_ collection: UICollectionView, _ indexPath: IndexPath, _ item: T) -> UICollectionViewCell? {
        guard let genre = item as? AnimeGenre else { return nil }
        return genreCell.cellProvider(collection, indexPath, genre)
    }
}
