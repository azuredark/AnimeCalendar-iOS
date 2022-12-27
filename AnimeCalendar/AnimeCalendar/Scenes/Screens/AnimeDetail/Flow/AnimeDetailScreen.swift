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

    /// # Components
    private(set) lazy var trailerComponent: TrailerCompatible = {
        let trailer = TrailerComponent(presenter: presenter)
        return trailer
    }()

    private lazy var descriptionContainer: UIView = {
        let container = UIView(frame: .zero)
        container.translatesAutoresizingMaskIntoConstraints = false
        container.backgroundColor = Color.cream
        view.addSubview(container)
        return container
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 3
        label.textColor = Color.black
        label.textAlignment = .left
        label.font = .boldSystemFont(ofSize: 24)
        view.addSubview(label)
        return label
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
        print("senku [DEBUG] \(String(describing: type(of: self))) - viewDidDisappear")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

private extension AnimeDetailScreen {
    func configureScreen() {
        view.backgroundColor = Color.cream
    }

    func bindAnime() {
        presenter?.anime
            .drive(onNext: { [weak self] anime in
                guard let self = self else { return }
                self.configureNavigationTitle(with: anime.titleKanji)
                self.configureTrailer(with: anime.trailer.youtubeId)
                self.configureDescriptionContainer(with: anime)
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
    func configureNavigationTitle(with title: String) {
        navigationBar.configureTitle(with: title)
    }

    func configureTrailer(with youtubeId: String) {
        let trailerContainer: UIView = trailerComponent.getContainer()
        view.addSubview(trailerContainer)

        let scale: CGFloat = 9 / 16
        NSLayoutConstraint.activate([
            trailerContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            trailerContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            trailerContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            trailerContainer.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: scale)
        ])
        
        trailerComponent.loadTrailer(withId: youtubeId)
    }
    
    func configureDescriptionContainer(with anime: Anime) {
        let xInset: CGFloat = 10.0
        let yInset: CGFloat = 5.0
        
        NSLayoutConstraint.activate([
            descriptionContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: xInset),
            descriptionContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -xInset),
            descriptionContainer.topAnchor.constraint(equalTo: trailerComponent.getContainer().bottomAnchor, constant: yInset),
            descriptionContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        configureTitleLabel(with: anime.titleEng)
    }

    func configureTitleLabel(with title: String) {
        titleLabel.text = title

        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: descriptionContainer.leadingAnchor),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: descriptionContainer.trailingAnchor),
            titleLabel.topAnchor.constraint(equalTo: descriptionContainer.topAnchor)
        ])
    }
}
