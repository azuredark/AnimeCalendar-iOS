//
//  UIImageView+LoadImage.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 20/01/23.
//

import UIKit
import Nuke
import RxCocoa
import RxSwift

/// Lookup **AppDelegate.swift** for PipeLine configurations.
// MARK: Can't use .withCheckedContinuation as Nuke.loadimage(:) completion sometimes doesn't callback.
extension UIImageView {
    typealias Completion = @MainActor (Bool) -> Void

    func loadImage(from path: String?, cellType: (any FeedCell)? = nil, _ completion: Completion? = nil) {
        guard let path = path else {
            completion?(false)
            return
        }
        
        let processors = ImageProcessor.process(for: cellType)
        let request = ImageRequest(url: URL(string: path),
                                   processors: processors)

        Nuke.loadImage(with: request, into: self) { result in
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

extension Reactive where Base: UIImageView {
    var imageSet: Observable<UIImage?> {
        observe(UIImage.self, "image")
    }
}
