//
//  ScreenComponentItemCollection.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 29/05/22.
//

import Foundation
import UIKit.UICollectionViewCell

protocol ComponentCollectionItem: ComponentItem & UICollectionViewCell {
    associatedtype T
    func setupItem(with item: T)
}
