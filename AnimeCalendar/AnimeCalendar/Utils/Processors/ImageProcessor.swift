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

    static func getProcessors(for cell: any FeedCell) -> [ImageProcessing] {
        
        // Add resizing processors.
        let processors: [ImageProcessing] = [
            ImageProcessors.Resize(size: cell.frame.size)
        ]

        return processors
    }
    
    static func getProcessors(for size: CGSize) -> [ImageProcessing] {
        // Add resizing processors.
        let processors: [ImageProcessing] = [
            ImageProcessors.Resize(size: size)
        ]

        return processors
    }
}
