//
//  AnimeCalendarScreen.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 27/04/22.
//

import Foundation
import UIKit.UIViewController

final class AnimeCalendarScreen: UIViewController, Screen {
    // MARK: State
    private weak var presenter: CalendarPresentable?
    
    // MARK: Initializers
    init(presenter: CalendarPresentable) {
        super.init(nibName: Xibs.animeCalendarScreenView, bundle: Bundle.main)
        self.presenter = presenter
        configureTabItem()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Life Cycle
extension AnimeCalendarScreen {
    override func viewDidLoad() {
        super.viewDidLoad()
        print("\(self) didLoad")
        configureScreen()
    }
}

// MARK: - Screen config
extension AnimeCalendarScreen {
    func configureScreen() {
        view.backgroundColor = Color.cream
        configureNavigationItems()
    }
}

// MARK: Navigation bar
extension AnimeCalendarScreen {
    func configureNavigationItems() {
        configureRightNavigationItems()
        configureLeftNavigationItems()
    }

    func configureRightNavigationItems() {}

    func configureLeftNavigationItems() {}
}

// MARK: - TabBar Item
extension AnimeCalendarScreen: ScreenWithTabItem {
    func configureTabItem() {
        view.autoresizingMask = .flexibleHeight
        let configuration = UIImage.SymbolConfiguration(weight: UIImage.SymbolWeight.bold)
        let tabImage = UIImage(systemName: "calendar", withConfiguration: configuration)!.withBaselineOffset(fromBottom: UIFont.systemFontSize * 1.5)
        tabBarItem = UITabBarItem(title: nil, image: tabImage, selectedImage: tabImage)
    }
}
