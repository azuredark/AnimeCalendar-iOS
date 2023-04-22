//
//  UIImageView+LoadImage.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 20/01/23.
//

import class UIKit.UIImageView
import Nuke

/// Lookup **AppDelegate.swift** for PipeLine configurations.
// MARK: Can't use .withCheckedContinuation as Nuke.loadimage(:) completion sometimes doesn't callback.
extension UIImageView {
    typealias Completion = @MainActor(Bool) -> Void

    @discardableResult
    func loadImage(from path: String?,
                   cellType: (any FeedCell)? = nil,
                   options: ImageRequest.Options = [],
                   completion: Completion? = nil) -> ImageTask? {
        guard let path = path else { completion?(false); return nil }

        // Image processing
        let processors = ImageProcessor.getProcessors(for: cellType)

        // Image request
        let request = ImageRequest(url: URL(string: path),
                                   processors: processors,
                                   options: options)

        return Nuke.loadImage(with: request, into: self) { result in
            switch result {
                case .success:
                    completion?(true)
                case .failure(let error):
                    print("senku [DEBUG] \(String(describing: type(of: self))) - loadImage(:) error: \(error)")
                    completion?(false)
            }
        }
    }
}
