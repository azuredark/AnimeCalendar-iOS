//
//  CustomTabBarController.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 5/05/22.
//

import UIKit

// TODO: (Improvement) Override tabbar and configure hittest to allow button taps outside the TabBar
final class CustomTabBarController: UITabBarController, TabBarProtocol {
    // MARK: State
    private lazy var newScheduledAnimeButton: TabBarButton = NewScheduledAnimeButton()

    // MARK: Initializers
    init() {
        super.init(nibName: nil, bundle: nil)
        configureTabBar()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CustomTabBarController: TabBarWithMiddleButton {
    func configureTabBar() {
        tabBar.backgroundColor = Color.white
        tabBar.unselectedItemTintColor = Color.lightGray
        tabBar.tintColor = Color.cobalt
        tabBar.itemPositioning = .centered
        tabBar.itemSpacing = CGFloat(180)
    }

    func configureMiddleButton() {
        newScheduledAnimeButton.createButton(in: tabBar)
    }

    func configureMiddleButtonAction(presenting newAnimeVC: UIViewController) {
        newScheduledAnimeButton.onTapAction = { [weak self] in
            guard let strongSelf = self else { return }
            newAnimeVC.modalPresentationStyle = .fullScreen
            strongSelf.present(newAnimeVC, animated: true)
        }
    }
}
