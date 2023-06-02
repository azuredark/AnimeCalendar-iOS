//
//  ACIcon.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 26/11/22.
//

import UIKit

enum ACIcon {
    /// # IOS 13.0+
    static var calendar: UIImage         { UIImage(systemName: "calendar") ?? UIImage() }
    static var tvFilled: UIImage         { UIImage(systemName: "tv.fill") ?? UIImage() }
    static var tv: UIImage               { UIImage(systemName: "tv") ?? UIImage() }
    static var starFilled: UIImage       { UIImage(systemName: "star.fill") ?? UIImage() }
    static var twoPeopleFilled: UIImage  { UIImage(systemName: "person.2.fill") ?? UIImage() }
    static var circleFilled: UIImage     { UIImage(systemName: "circle.fill") ?? UIImage() }
    static var globe: UIImage            { UIImage(systemName: "globe") ?? UIImage() }
    static var magnifyingglass: UIImage  { UIImage(systemName: "magnifyingglass") ?? UIImage() }
    static var house: UIImage            { UIImage(systemName: "house") ?? UIImage() }
    static var peopleFilled: UIImage     { UIImage(systemName: "person.3.fill") ?? UIImage() }
    static var textQuote: UIImage        { UIImage(systemName: "text.quote") ?? UIImage() }
    
    /// # Font Awesome
    static var faStarFilled: UIImage     { UIImage(named: "fa-star-filled") ?? UIImage() }
    static var faStarFilledHalf: UIImage { UIImage(named: "fa-star-filled-half") ?? UIImage() }
    static var faStar: UIImage           { UIImage(named: "fa-star") ?? UIImage() }
    static var faClock: UIImage          { UIImage(named: "fa-clock") ?? UIImage() }
    
    /// # Others
    static var trophy: UIImage           { UIImage(named: "icon-trophy")! }
}
