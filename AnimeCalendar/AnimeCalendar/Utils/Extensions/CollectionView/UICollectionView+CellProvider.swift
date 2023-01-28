//
//  UICollectionView+CellProvider.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 5/01/23.
//

import UIKit

extension UICollectionView.CellRegistration {
    var cellProvider: (UICollectionView, IndexPath, Item) -> Cell {
        return { (collectionView, indexPath, item) in
            collectionView.dequeueConfiguredReusableCell(using: self,
                                                         for: indexPath,
                                                         item: item)
        }
    }
}
