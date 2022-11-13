//
//  DiscoverScreen.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 13/11/22.
//

import UIKit

final class DiscoverScreen: UIViewController, Screen {
    // MARK: State
    /// # Presenter
    private weak var presenter: DiscoverPresentable?

    /// # Navigation bar
    private lazy var navigationBar: ScreenNavigationBar = {
        DiscoverScreenNavigationBar(self)
    }()

    // MARK: Initializers
    init(presenter: DiscoverPresentable) {
        super.init(nibName: nil, bundle: nil)
        self.presenter = presenter
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Life Cycle
extension DiscoverScreen {
    override func viewDidLoad() {
        configureScreen()
    }
}

extension DiscoverScreen {
    func configureScreen() {
        view.backgroundColor = Color.cream
        configureNavigationItems()
        configureScreenComponents()
    }
}

// MARK: - Configure components (UI)
extension DiscoverScreen {
    func configureScreenComponents() {}
}

// MARK: - Navigation Bar
extension DiscoverScreen {
    func configureNavigationItems() {
        configureNavigationTitle()
        configureLeftNavigationItems()
        configureRightNavigationItems()
    }
    
    func configureNavigationTitle() {
        navigationBar.configureTitle()
    }

    func configureLeftNavigationItems() {
        navigationBar.configureLeftNavigationItems()
    }

    func configureRightNavigationItems() {
        navigationBar.configureRightNavigationItems()
    }
}

// MARK: - Root view controller
extension DiscoverScreen: RootViewController {
    func getRootViewController() -> UIViewController {
        return CustomNavigationController(self)
    }
}
