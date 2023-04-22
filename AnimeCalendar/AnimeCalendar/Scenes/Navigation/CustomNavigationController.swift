//
//  CustomNavigationController.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 5/05/22.
//

import UIKit

final class CustomNavigationController: UINavigationController {
    /// # State

    /// # Initializers
    init() {
        /// Settings
        let appearance = UINavigationBarAppearance()
        
        super.init(nibName: nil, bundle: nil)
        navigationBar.standardAppearance = appearance
        navigationBar.scrollEdgeAppearance = appearance
        navigationBar.compactAppearance = appearance
//        navigationBar.backgroundColor = Color.cream
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setBackground(with color: UIColor) {
    }
}
