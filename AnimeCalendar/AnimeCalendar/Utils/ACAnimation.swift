//
//  ACAnimation.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 26/11/22.
//

import UIKit

typealias AnimationCompleted = () -> Void

extension UIView {
    func expand(durationInSeconds duration: TimeInterval, end: AnimationEnd, toScale scale: CGFloat, _ animationCompleted: AnimationCompleted? = nil ) {
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
    
    func fadeIn(duration: CGFloat, delay: CGFloat = 0, _ animationCompleted: AnimationCompleted? = nil) {
        self.alpha = 0
        
        let animation: () -> Void = {
            self.alpha = 1
        }
        
        let completion: (Bool) -> Void = { _ in
            animationCompleted?()
        }
        
        UIView.animate(withDuration: duration, delay: delay, animations: animation, completion: completion)
    }
}

enum AnimationEnd {
    case reset
    case keep
}
