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
    weak var coverImage: UIImage?

    /// # Navigation Bar
    private lazy var navigationBar: ScreenNavigationBar = {
        AnimeDetailNavigationBar(self)
    }()

    /// # Main collection
    private lazy var detailFeed: DetailFeed = {
        let feed = DetailFeed(presenter: presenter)
        return feed
    }()
    
    /// # Background Image
    private lazy var coverImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.image = coverImage
        view.insertSubview(imageView, at: 0)
        return imageView
    }()
    
    private lazy var blurView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .systemChromeMaterial)
        let visualEffect = UIVisualEffectView(effect: blurEffect)
        visualEffect.translatesAutoresizingMaskIntoConstraints = false
        
        view.insertSubview(visualEffect, aboveSubview: coverImageView)
        return visualEffect
    }()
    
    private lazy var disposeBag = DisposeBag()

    // MARK: Initializers
    init(presenter: AnimeDetailPresentable) {
        self.presenter = presenter

        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        print("senku [DEBUG] \(String(describing: type(of: self))) - DE-INTIALIZED")
        presenter?.cleanRequests()
    }

    func getDetailFeed() -> DetailFeed {
        return detailFeed
    }
}

// MARK: - Life Cycle
extension AnimeDetailScreen {
    override func viewDidLoad() {
        super.viewDidLoad()
        configureScreen()
        bindAnime()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

private extension AnimeDetailScreen {
    func configureScreen() {
        configureNavigationItems()
        layoutCollection()
        layoutCoverImageView()
        layoutBlurView()
    }

    func bindAnime() {
        presenter?.anime
            .drive(onNext: { [weak self] (anime) in
                guard let self = self else { return }
                Logger.log(.info, msg: "RX DID LOAD ANIME: \(anime.titleEng)")
                
                self.configureNavigationTitle(with: anime.titleKanji)
                self.presenter?.updateCharacters(animeId: Int(anime.id) ?? 49387)
                self.presenter?.updateReviews(animeId: Int(anime.id) ?? 49387)
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
            mainCollection.topAnchor.constraint(equalTo: view.topAnchor),
            mainCollection.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func layoutCoverImageView() {
        coverImageView.fitViewTo(view)
        view.layoutIfNeeded()
    }
    
    func layoutBlurView() {
        blurView.fitViewTo(coverImageView)
    }

    func configureNavigationTitle(with title: String) {
        navigationBar.configureTitle(with: title)
    }
}

// MARK: - Delegates
extension AnimeDetailScreen {}
