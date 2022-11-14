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

    private lazy var screenContainer: UIView = {
        let container = UIView(frame: .zero)
        container.translatesAutoresizingMaskIntoConstraints = false
        container.backgroundColor = .clear
        view.addSubview(container)
        return container
    }()

    /// # Components
    private lazy var searchbBar: DiscoverSearchBar = {
        let searchBar = DiscoverSearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        return searchBar
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
        configureScreenContainer()
        configureNavigationItems()
        configureScreenComponents()
    }

    func configureScreenContainer() {
        #warning("This must be some sort of scroll view object subclass or the class itself idk")
        let xInset: CGFloat = 20.0
        NSLayoutConstraint.activate([
            screenContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: xInset),
            screenContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -xInset),
            screenContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            screenContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
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

// MARK: - Configure components (UI)
private extension DiscoverScreen {
    func configureScreenComponents() {
        configureSearchBarView()
    }
}

private extension DiscoverScreen {
    func configureSearchBarView() {
        screenContainer.addSubview(searchbBar)
        let height: CGFloat = 35.0
        let yInset: CGFloat = 10.0

        NSLayoutConstraint.activate([
            searchbBar.leadingAnchor.constraint(equalTo: screenContainer.leadingAnchor),
            searchbBar.trailingAnchor.constraint(equalTo: screenContainer.trailingAnchor),
            searchbBar.topAnchor.constraint(equalTo: screenContainer.topAnchor, constant: yInset),
            searchbBar.heightAnchor.constraint(equalToConstant: height)
        ])
    }
}

// MARK: - Root view controller
extension DiscoverScreen: RootViewController {
    func getRootViewController() -> UIViewController {
        return CustomNavigationController(self)
    }
}
