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
        let searchBar = DiscoverSearchBar(presenter: presenter)
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        return searchBar
    }()

    /// Feed made of a compostional collection view containing all sections and items
    private lazy var feed: Feed = {
        return Feed(presenter: presenter)
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
        updateLatestFeed()
    }
}

private extension DiscoverScreen {
    func updateLatestFeed() {
        print("senku [DEBUG] \(String(describing: type(of: self))) - updateLatestFeed")
        presenter?.updateSeasonAnime()
        presenter?.updateRecentPromosAnime()
        presenter?.updateTopAnime(by: .rank)
    }
}

private extension DiscoverScreen {
    func configureScreen() {
        view.backgroundColor = Color.cream
        layoutScreenContainer()
        configureNavigationItems()
        configureScreenComponents()
    }

    func layoutScreenContainer() {
        NSLayoutConstraint.activate([
            screenContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            screenContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
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
        configureFeed()
    }
}

private extension DiscoverScreen {
    func configureSearchBarView() {
        screenContainer.addSubview(searchbBar)
        let height: CGFloat = 35.0
        let yInset: CGFloat = 10.0
        let xInset: CGFloat = 20.0

        NSLayoutConstraint.activate([
            searchbBar.leadingAnchor.constraint(equalTo: screenContainer.leadingAnchor, constant: xInset),
            searchbBar.trailingAnchor.constraint(equalTo: screenContainer.trailingAnchor, constant: -xInset),
            searchbBar.topAnchor.constraint(equalTo: screenContainer.topAnchor, constant: yInset),
            searchbBar.heightAnchor.constraint(equalToConstant: height)
        ])
    }

    func configureFeed() {
        let feedCollection = feed.getCollection()
        screenContainer.addSubview(feedCollection)
        
        let yInset: CGFloat = 10.0
        NSLayoutConstraint.activate([
            feedCollection.leadingAnchor.constraint(equalTo: screenContainer.leadingAnchor),
            feedCollection.trailingAnchor.constraint(equalTo: screenContainer.trailingAnchor),
            feedCollection.topAnchor.constraint(equalTo: searchbBar.bottomAnchor, constant: yInset),
            feedCollection.bottomAnchor.constraint(equalTo: screenContainer.bottomAnchor)
        ])
    }
}
