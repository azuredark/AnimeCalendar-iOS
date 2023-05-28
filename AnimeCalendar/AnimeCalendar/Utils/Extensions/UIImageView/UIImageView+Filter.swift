//
//  UIImageView+Filter.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 27/05/23.
//

import class UIKit.UIImageView
import class CoreImage.CIImage

extension UIImageView {
    /// Applies a specified filter to a UIImageView's image with certain parameters if needed.
    /// - Parameter key: A KeyPath which subscribes to the FilterSource.
    /// - Parameter params: Optional additional params for the filter.
    ///
    /// - Warning: This **must** be run **after** the **UIImageView's image** has been set
    /// or there will be no effect whatsoever.
    func applyFilter(_ key: KeyPath<ACFilterSource, Filter>, params additionalValues: [FilterValues] = []) {
        // Map and get the desired filter
        let filter = ACFilterSource.shared[key].filter

        // Apply the filter using params.
        Task(priority: .userInitiated) {
            guard let cgImage = image?.cgImage else { return }

            let ciImage = CIImage(cgImage: cgImage)
            filter.apply(with: &image,
                         inputCIImage: ciImage,
                         additionalValues: additionalValues,
                         updateImage: true)
        }
    }
}
