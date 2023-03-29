//
//  ImageProcessor.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 21/01/23.
//

import Foundation
import Nuke

struct ImageProcessor {
    typealias ImageDimension = (width: CGFloat, height: CGFloat)
    init() {}

    static func process(for cellType: (any FeedCell)?) -> [ImageProcessing] {
        guard let cellType = cellType else { return [] }
        
        var processors = [ImageProcessing]()
        
        if cellType is SeasonAnimeCell {
            let height: CGFloat = 300.0
            let width: CGFloat = height / 1.66 // 16:9
            processors.append(contentsOf: [
                .resize(width: width),
                .resize(height: height)
            ])
        }
        
        return processors
    }
}
