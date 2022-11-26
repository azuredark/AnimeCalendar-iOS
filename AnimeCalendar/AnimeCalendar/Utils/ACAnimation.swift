//
//  ACAnimation.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 26/11/22.
//

import UIKit

typealias AnimationCompleted = () -> Void

extension UIView {
    func expand(lasting duration: TimeInterval, end: AnimationEnd, toScale scale: CGFloat, _ animationCompleted: AnimationCompleted? = nil ) {
        let completionReset: (Bool) -> Void = { _ in
            if case .reset = end {
                UIView.animate(withDuration: duration) { [weak self] in
                    self?.transform = .identity
                    animationCompleted?()
                }
            } else { animationCompleted?() }
        }
        
        let animation: () -> Void = {
            let transform = CGAffineTransform(scaleX: scale, y: scale)
            self.transform = transform
        }

        UIView.animate(withDuration: duration, animations: animation, completion:  completionReset)
    }
}

enum AnimationEnd {
    case reset
    case keep
}
