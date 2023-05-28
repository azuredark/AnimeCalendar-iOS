//
//  ClampImageFilter.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 27/05/23.
//

import CoreImage
import class UIKit.UIImageView
import class UIKit.UIImage

final class ClampImageFilter: ImageFilter {
    // MARK: State
    let filter = CIFilter(name: FilterName.clamp.value)
    
    // MARK: Initializers
    init() {}
    
    // MARK: Methods
    func apply(with image: inout UIImage?, inputCIImage: CIImage, additionalValues: [FilterValues], updateImage: Bool) -> CIImage? {
        filter?.setDefaults()
        filter?.setValue(inputCIImage, forKey: kCIInputImageKey)
        
        guard let outputCIImage = filter?.outputImage else { return nil }
        
        if updateImage {
            image = UIImage(ciImage: outputCIImage)
        }
        
        return outputCIImage
    }
}
