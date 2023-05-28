//
//  ACImageFilter.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 27/05/23.
//

import CoreImage
import class UIKit.UIImage

protocol ImageFilter {
    var filter: CIFilter? { get }

    @discardableResult
    func apply(with image: inout UIImage?,
               inputCIImage: CIImage,
               additionalValues: [FilterValues],
               updateImage: Bool) -> CIImage?
}

extension ImageFilter {
    func addParams(params: [FilterValues]) {
        for param in params {
            filter?.setValue(param.ciValue.value, forKey: param.ciValue.key)
        }
    }
}
