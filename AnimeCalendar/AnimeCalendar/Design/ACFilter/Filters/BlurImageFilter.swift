//
//  BlurImageFilter.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 27/05/23.
//

import CoreImage
import class UIKit.UIImage

final class BlurImageFilter: ImageFilter {
    // MARK: State
    let filter = CIFilter(name: FilterName.cIGaussianBlur.value)

    // MARK: Initializers
    init() {}

    // MARK: Methods
    func apply(with image: inout UIImage?, inputCIImage: CIImage, additionalValues: [FilterValues], updateImage: Bool) -> CIImage? {
        // Additonal filters
        let clampFilter = ACFilterSource.shared[\.clamp].filter

        let clampCIImage = clampFilter.apply(with: &image,
                                             inputCIImage: inputCIImage,
                                             additionalValues: [],
                                             updateImage: false)

        filter?.setValue(clampCIImage, forKey: kCIInputImageKey)

        addParams(params: additionalValues)

        // Update image.
        guard let outputCIImage = filter?.value(forKey: kCIOutputImageKey) as? CIImage,
              let outputCGImage = ACFilterSource.shared.ciContext.createCGImage(outputCIImage,
                                                                         from: inputCIImage.extent) else { return nil }

        if updateImage {
            let scale = image?.scale ?? 1.0
            image = UIImage(cgImage: outputCGImage, scale: scale, orientation: .up)
        }

        return outputCIImage
    }
}
