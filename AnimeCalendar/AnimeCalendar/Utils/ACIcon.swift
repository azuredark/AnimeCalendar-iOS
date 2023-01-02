//
//  ACIcon.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 26/11/22.
//

import UIKit

enum ACIcon {
    // IOS 13.0+
    static var trophy: UIImage { UIImage(named: "icon-trophy")! }
    static var calendar: UIImage { UIImage(systemName: "calendar") ?? UIImage(named: "icon-trophy")! }
    static var tvFilled: UIImage { UIImage(systemName: "tv.fill") ?? UIImage(named: "icon-trophy")! }
    static var starFilled: UIImage { UIImage(systemName: "star.fill") ?? UIImage(named: "icon-trophy")! }
    static var twoPeopleFilled: UIImage { UIImage(systemName: "person.2.fill") ?? UIImage(named: "icon-trophy")! }
    static var circleFilled: UIImage { UIImage(systemName: "circle.fill") ?? UIImage() }
}
