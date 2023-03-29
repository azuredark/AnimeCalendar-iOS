//
//  DiscoverScreen.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 13/11/22.
//

import UIKit
import RxSwift

final class DiscoverScreen: UIViewController, Screen {
    // MARK: State
    /// # Presenter
    private weak var presenter: DiscoverPresentable?
    private let disposeBag = DisposeBag()

    /// # Navigation bar
    private lazy var navigationBar = DiscoverScreenNavigationBar(self)

    /// # Components
    private lazy var searchbBar: DiscoverSearchBar = {
        let searchBar = DiscoverSearchBar(presenter: presenter)
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        return searchBar
    }()

    private lazy var refreshControl: UIRefreshControl = {
        let refresh = UIRefreshControl(frame: .zero)
        refresh.translatesAutoresizingMaskIntoConstraints = false
        refresh.addTarget(self, action: #selector(didScrollToRefresh), for: .valueChanged)
        return refresh
    }()

    /// Feed made of a compostional collection view containing all sections and items
    private lazy var feed = Feed(presenter: presenter)
    /// Feed's collection
    private lazy var feedCollection: UICollectionView = feed.getCollection()

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
        // 1. Reset snapshot from Feed's data source.
        presenter?.resetAllAnimeData()
        feed.getDataSource().resetSnapshot()

        // 2. Add loaders
        presenter?.addLoaderItems()

        // 3. Request new data.
        presenter?.updateRecentPromosAnime()
        presenter?.updateSeasonAnime()
        presenter?.updateUpcomingAnime()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: { [weak self] in
            self?.presenter?.updateTopAnime(by: .rank)
        })
    }
}

private extension DiscoverScreen {
    func configureScreen() {
        view.backgroundColor = Color.cream
        configureNavigationItems()
        configureScreenComponents()
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
//        configureSearchBarView()
        configureFeed()
        configureRefreshControl()
    }
}

private extension DiscoverScreen {
    func configureSearchBarView() {
        view.addSubview(searchbBar)
        let height: CGFloat = 35.0
        let yInset: CGFloat = 10.0
        let xInset: CGFloat = 20.0

        NSLayoutConstraint.activate([
            searchbBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: xInset),
            searchbBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -xInset),
            searchbBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: yInset),
            searchbBar.heightAnchor.constraint(equalToConstant: height)
        ])
    }

    func configureFeed() {
        view.addSubview(feedCollection)

        let yInset: CGFloat = 0
        NSLayoutConstraint.activate([
            feedCollection.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            feedCollection.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            feedCollection.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: yInset),
            feedCollection.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    func configureRefreshControl() {
        feedCollection.refreshControl = refreshControl
    }
}

private extension DiscoverScreen {
    @objc func didScrollToRefresh() {
        Logger.log(.info, msg: "Did scroll to refresh owo")

        // 1. Wait for at least 1 new feed load to end the refreshing animation
        presenter?.recievedValidAnime
            .asObservable()
            .observe(on: MainScheduler.instance)
            .filter { $0 }
            .subscribe(onNext: { [weak self] (_) in
                guard let self else { return }
                self.refreshControl.endRefreshing()
            })
            .disposed(by: disposeBag)

        // 2. Request new feed.
        updateLatestFeed()
    }
}
