//
//  ACReusable.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 28/05/23.
//

import UIKit

protocol ACReusable: UICollectionReusableView {
    var reuseId: String { get }
}

extension ACReusable {
    var reuseId: String { String(describing: Self.self) }
}
