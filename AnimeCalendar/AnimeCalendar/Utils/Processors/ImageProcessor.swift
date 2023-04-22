//
//  ImageProcessor.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 21/01/23.
//

import Nuke

struct ImageProcessor {
    typealias ImageDimension = (width: CGFloat, height: CGFloat)
    init() {}

    static func getProcessors(for cell: (any FeedCell)?) -> [ImageProcessing] {
        guard let cell else { return [] }

        // Add resizing processors.
        let processors: [ImageProcessing] = [
            ImageProcessors.Resize(size: cell.frame.size)
        ]

        return processors
    }
}
