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
    
    /// # Singleton
    static let shared = ACFilterSource()
    
    subscript(value: KeyPath<ACFilterSource, Filter>) -> Filter {
        get { return self[keyPath: value] }
    }
    
    private init() {
        ciContext = CIContext(mtlDevice: MTLCreateSystemDefaultDevice()!)
    }
    
    /// # Methods
    func preloadFilters(_ filters: [FilterName]) {
        for filter in filters {
            switch filter {
                case .cIGaussianBlur:
                    _ = blur
                case .clamp:
                    _ = clamp
                case .all: preloadFilters([.cIGaussianBlur, .clamp])
            }
        }
    }
}
