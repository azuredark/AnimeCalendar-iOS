//
//  FilterSource.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 27/05/23.
//

import CoreImage

enum FilterName: String, CaseIterable {
    case cIGaussianBlur = "CIGaussianBlur"
    case clamp          = "CIAffineClamp"
    case areaAverage    = "CIAreaAverage"
    case all
    
    var value: String { self.rawValue }
}

typealias Filter = (name: FilterName, filter: any ImageFilter)
final class ACFilterSource {
    /// # CIContext
    let ciContext: CIContext
    
    /// # CIGaussianBlur
    private(set) lazy var blur: Filter = (name: .cIGaussianBlur, BlurImageFilter())
    /// # ClampFilter
    private(set) lazy var clamp: Filter = (name: .clamp, ClampImageFilter())
    /// # CIAreaAverage
    private(set) lazy var areaAverageColor: Filter = (name: .areaAverage, AreaAverageFilter())
    
    /// # Singleton
    static let shared = ACFilterSource()
    
    subscript(value: KeyPath<ACFilterSource, Filter>) -> Filter { return self[keyPath: value] }
    
    private init() {
        ciContext = CIContext(options: [
            CIContextOption.workingColorSpace: kCFNull!
        ])
    }
    
    /// # Methods
    func preloadFilters(_ filters: [FilterName]) {
        for filter in filters {
            switch filter {
                case .cIGaussianBlur: _ = blur
                case .clamp:          _ = clamp
                case .areaAverage:    _ = areaAverageColor
                case .all:
                    preloadFilters([.cIGaussianBlur, .clamp, .areaAverage])
            }
        }
    }
}
