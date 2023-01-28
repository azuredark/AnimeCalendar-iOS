//
//  AnimeDetailScreen.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 26/12/22.
//

import RxSwift
import RxCocoa

final class AnimeDetailScreen: UIViewController, Screen {
    // MARK: State
    private weak var presenter: AnimeDetailPresentable?

    /// # Navigation Bar
    private lazy var navigationBar: ScreenNavigationBar = {
        AnimeDetailNavigationBar(self)
    }()
    
    /// # Main collection
    private lazy var detailFeed: DetailFeed = {
        let feed = DetailFeed(presenter: presenter)
        return feed
    }()

    private lazy var disposeBag = DisposeBag()

    // MARK: Initializers
    init(presenter: AnimeDetailPresentable) {
        super.init(nibName: nil, bundle: nil)
        self.presenter = presenter
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        print("senku [DEBUG] \(String(describing: type(of: self))) - deinted")
    }
    
    func getDetailFeed() -> DetailFeed {
        return detailFeed
    }
}

// MARK: - Life Cycle
extension AnimeDetailScreen {
    override func viewDidLoad() {
        super.viewDidLoad()
        print("senku [DEBUG] \(String(describing: type(of: self))) - viewDidLoad")
        configureScreen()
        bindAnime()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        presenter?.disposeTrailerComponent()
        print("senku [DEBUG] \(String(describing: type(of: self))) - viewDidDisappear")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

private extension AnimeDetailScreen {
    func configureScreen() {
        configureNavigationItems()
        layoutCollection()
    }

    func bindAnime() {
        presenter?.anime
            .drive(onNext: { [weak self] anime in
                guard let self = self else { return }
                self.configureNavigationTitle(with: anime.titleKanji)
                print("senku [DEBUG] \(String(describing: type(of: self))) - RX NAVIGATION TITLE")
            }).disposed(by: disposeBag)
    }
}

// MARK: Screen
extension AnimeDetailScreen {
    func configureNavigationItems() {
        configureRightNavigationItems()
        configureLeftNavigationItems()
    }

    func configureRightNavigationItems() {
        navigationBar.configureLeftNavigationItems()
    }

    func configureLeftNavigationItems() {
        navigationBar.configureRightNavigationItems()
    }
}

// MARK: - Anime configuration
private extension AnimeDetailScreen {
    func layoutCollection() {
        let mainCollection = detailFeed.getCollection()
        view.addSubview(mainCollection)

        NSLayoutConstraint.activate([
            mainCollection.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mainCollection.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mainCollection.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mainCollection.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    func configureNavigationTitle(with title: String) {
        navigationBar.configureTitle(with: title)
    }
}

// MARK: - Delegates
extension AnimeDetailScreen {}
