//
//  ACCollection.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 4/01/23.
//

import UIKit

protocol ACCollectionDataSourceable: AnyObject {
    func registerCells()
    func provideCell<T: Hashable>(_ collection: UICollectionView, _ indexPath: IndexPath, _ item: T) -> UICollectionViewCell?
}

protocol ACColllectionLayoutable: AnyObject {
    func getSection(_ sectionIndex: Int, _ env: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection?
}

final class ACCollection<Section: Hashable, Item: Hashable>: ACUIDesignable {
    // MARK: State
    /// # Typealias
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Item>
    typealias DataSource = UICollectionViewDiffableDataSource<Section, Item>

    /// # CollectionView
    private lazy var collectionView: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: getLayout())
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.showsVerticalScrollIndicator = false
        collection.showsHorizontalScrollIndicator = false
        collection.alwaysBounceVertical = false
        collection.backgroundColor = Color.cream
        return collection
    }()
    
    /// # Snapshot
    private var snapshot = Snapshot()
    
    /// # DataSource
    private lazy var dataSource: DataSource? = {
        let ds = getDataSource()
        collectionView.dataSource = ds
        return ds
    }()

    /// # Delegates
    weak var dataSourceDelegate: ACCollectionDataSourceable?
    weak var layoutDelegate: ACColllectionLayoutable?
    
    // MARK: Initializers
    init() {}

    // MARK: Methods
    
    /// Must be called before any other method.
    func setup() {
        registerCells()
    }
    
    func getCollection() -> UICollectionView {
        return collectionView
    }
    
    func updateSnapshot(completion: () -> (Section, [Item]?)) {
        let sectionItem: (section: Section, item: [Item]?) = completion()
        
        // Check if section already exists
        if snapshot.indexOfSection(sectionItem.section) == nil {
            snapshot.appendSections([sectionItem.section])
        }
        
        guard let item = sectionItem.item else { return }
        
        snapshot.appendItems(item, toSection: sectionItem.section)
        dataSource?.apply(snapshot, animatingDifferences: true)
    }
    
    func reset() {
        snapshot = Snapshot()
    }
}

private extension ACCollection {
    func registerCells() {
        dataSourceDelegate?.registerCells()
    }
    
    func getDataSource() -> DataSource {
        return DataSource(collectionView: collectionView, cellProvider: { [weak self] collectionView, indexPath, item in
            guard let self = self else { return nil }
            return self.dataSourceDelegate?.provideCell(collectionView, indexPath, item)
        })
    }
    
    func getLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { [weak self] sectionIndex, environment in
            guard let self = self else {
                fatalError("senku [❌] \(String(describing: type(of: self))) - Error: No instance found.")
            }
            return self.layoutDelegate?.getSection(sectionIndex, environment)
        }
    }
}
