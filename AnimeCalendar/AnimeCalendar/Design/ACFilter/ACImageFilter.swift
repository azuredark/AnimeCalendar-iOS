//
//  ACImageFilter.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 27/05/23.
//

import CoreImage
import class UIKit.UIImage
import class UIKit.UIColor

protocol ImageFilter {
    var filter: CIFilter? { get }
    
    @discardableResult
    func apply(with image: inout UIImage?,
               inputCIImage: CIImage,
               additionalValues: [FilterValues],
               updateImage: Bool) -> CIImage?
    
    @discardableResult
    func apply(inputCIImage: CIImage, additionalValues: [FilterValues], completion: ((UIColor?) -> Void)?) -> UIColor?
}

extension ImageFilter {
    func addParams(params: [FilterValues]) {
        for param in params {
            filter?.setValue(param.ciValue.value, forKey: param.ciValue.key)
        }
    }

    func apply(with image: inout UIImage?,
               inputCIImage: CIImage,
               additionalValues: [FilterValues],
               updateImage: Bool) -> CIImage? { nil }

    func apply(inputCIImage: CIImage, additionalValues: [FilterValues] = [], completion: ((UIColor?) -> Void)? = nil) -> UIColor? { nil }
}
