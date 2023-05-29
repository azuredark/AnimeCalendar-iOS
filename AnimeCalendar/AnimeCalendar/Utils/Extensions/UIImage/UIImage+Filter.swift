//
//  UIImage+Filter.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 28/05/23.
//

import CoreImage
import class UIKit.UIImage
import class UIKit.UIColor

extension UIImage {
    func getThemeColor(completion: ((UIColor?) -> Void)?) {
        let filter = ACFilterSource.shared[\.areaAverageColor].filter
        Task(priority: .userInitiated) {
            guard let ciImage = CIImage(image: self) else { completion?(nil); return }
            
            filter.apply(inputCIImage: ciImage, additionalValues: []) { color in
                completion?(color)
            }
        }
    }
}
