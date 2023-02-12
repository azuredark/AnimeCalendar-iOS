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
    
    private lazy var blurView: BlurContainer = {
        let config = BlurContainer.Config(opacity: 0.9, style: .systemThickMaterial)
        let blur = BlurContainer(config: config)
        blur.translatesAutoresizingMaskIntoConstraints = false
        view.insertSubview(blur, aboveSubview: coverImageView)
        return blur
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
        print("\n")
        print("senku [DEBUG] \(String(describing: type(of: self))) - VIEW DID LOAD")
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
                self.configureNavigationTitle(with: anime.titleKanji)
                self.presenter?.updateCharacters(animeId: anime.id)
                print("senku [DEBUG] \(String(describing: type(of: self))) - RX DID LOAD ANIME: \(anime.titleEng)")
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
    
    func layoutCoverImageView() {
        coverImageView.fitViewTo(view)
    }
    
    func layoutBlurView() {
        blurView.fitViewTo(view)
    }

    func configureNavigationTitle(with title: String) {
        navigationBar.configureTitle(with: title)
    }
}

// MARK: - Delegates
extension AnimeDetailScreen {}
