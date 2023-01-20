//
//  UIImageView+LoadImage.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 20/01/23.
//

import UIKit.UIImageView
import Nuke

/// Lookup **AppDelegate.swift** for PipeLine configurations.
extension UIImageView {
    func loadImage(from path: String, cellType: (any FeedCell)? = nil) {
        var processors = [ImageProcessing]()
        
        if let cellType = cellType {
            if cellType is SeasonAnimeCell {
                let height: CGFloat = 250.0
                let width: CGFloat = height / 1.66 // 16:9
                processors.append(contentsOf: [
                    .resize(width: width),
                    .resize(height: height)
                ])
            }
        }
        
        let request = ImageRequest(url: URL(string: path),
                                   processors: processors)
        Nuke.loadImage(with: request, into: self)
    }
}
