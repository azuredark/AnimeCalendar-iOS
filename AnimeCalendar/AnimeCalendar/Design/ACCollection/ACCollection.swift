//
//  ACCollection.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 4/01/23.
//

import UIKit

protocol ACCollectionDataSourceable: AnyObject {
    func registerCells()
    func registerHeaders()
    func provideCell<T: Hashable>(_ collection: UICollectionView, _ indexPath: IndexPath, _ item: T) -> UICollectionViewCell?
    func provideHeader(_ collection: UICollectionView, _ indexPath: IndexPath, _ kind: String) -> UICollectionReusableView?
}

extension ACCollectionDataSourceable {
    func registerHeaders() {}
    func provideHeader(_ collection: UICollectionView, _ indexPath: IndexPath, _ kind: String) -> UICollectionReusableView? { return nil }
}

protocol ACColllectionLayoutable: AnyObject {
    func getSection(_ sectionIndex: Int, _ env: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection?
}

final class ACCollection<Section: Hashable, Item: Hashable>: ACUIDesignable {
    // MARK: State
    /// # Typealias
    private typealias AccessId = ACCollectionIdentifiers
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Item>
    typealias DataSource = UICollectionViewDiffableDataSource<Section, Item>
    
    /// # CollectionView
    private lazy var collectionView: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: getLayout())
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.accessibilityIdentifier = AccessId.collection
        collection.showsVerticalScrollIndicator = false
        collection.showsHorizontalScrollIndicator = false
        collection.alwaysBounceVertical = false
        collection.backgroundColor = .clear
        return collection
    }()
    
    /// # Snapshot
    private var snapshot = Snapshot()
    
    /// # DataSource
    private var dataSource: DataSource?

    /// # Delegates
    weak var dataSourceDelegate: ACCollectionDataSourceable?
    weak var layoutDelegate: ACColllectionLayoutable?
    
    // MARK: Initializers
    init() {
        buildDataSource()
    }

    // MARK: Methods
    
    /// Must be called before any other method.
    func setup() {
        registerCells()
        registerHeaders()
    }
    
    func getCollection() -> UICollectionView {
        return collectionView
    }
    
    func getDataSource() -> DataSource? {
        return dataSource
    }
    
    func updateSnapshot(completion: () -> (Section, [Item]?)) {
        let sectionItem: (section: Section, item: [Item]?) = completion()
        guard !(snapshot.itemIdentifiers == sectionItem.item) else { return }
        
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
    
    func registerHeaders() {
        dataSourceDelegate?.registerHeaders()
    }
    
    func buildDataSource()  {
        dataSource = DataSource(collectionView: collectionView) { [weak self] (collectionView, indexPath, item) in
            guard let self = self else { return nil }
            return self.dataSourceDelegate?.provideCell(collectionView, indexPath, item)
        }
        
        dataSource?.supplementaryViewProvider = { [weak self] (collection, kind, indexPath) -> UICollectionReusableView? in
            guard let self = self else { return EmptyHeader() }
            return self.dataSourceDelegate?.provideHeader(collection, indexPath, kind)
        }

        collectionView.dataSource = dataSource
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
