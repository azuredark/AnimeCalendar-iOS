//
//  AreaAverageFilter.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 28/05/23.
//

import CoreImage
import class UIKit.UIImage
import class UIKit.UIColor

final class AreaAverageFilter: ImageFilter {
    // MARK: State
    private(set) var filter = CIFilter(name: FilterName.areaAverage.value)
    
    // MARK: Initializers
    init() {}
    
    // MARK: Methods
    func apply(inputCIImage: CIImage, additionalValues: [FilterValues] = [], completion: ((UIColor?) -> Void)?) -> UIColor? {
        let extentVector = CIVector(x: inputCIImage.extent.origin.x,
                                    y: inputCIImage.extent.origin.y,
                                    z: inputCIImage.extent.size.width,
                                    w: inputCIImage.extent.size.height)
        filter?.setValue(inputCIImage, forKey: kCIInputImageKey)
        filter?.setValue(extentVector, forKey: kCIInputExtentKey)
        
        addParams(params: additionalValues)
        
        guard let outputCIImage = filter?.outputImage else {
            completion?(nil)
            return nil
        }
        
        var bitmap = [UInt8](repeating: 0, count: 4)
        
        ACFilterSource.shared.ciContext.render(outputCIImage,
                                               toBitmap: &bitmap,
                                               rowBytes: 4,
                                               bounds: CGRect(x: 0, y: 0, width: 1, height: 1),
                                               format: CIFormat.RGBA8,
                                               colorSpace: nil)
        
        let color = UIColor(red: CGFloat(bitmap[0])/255,
                            green: CGFloat(bitmap[1])/255,
                            blue: CGFloat(bitmap[2])/255,
                            alpha: CGFloat(bitmap[3])/255)
        
        completion?(color)
        return color
    }
}
