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
    private var presenter: AnimeDetailPresentable?
    private var cellIsSelectable: Bool = true
    private var animeIsPreLoaded: Bool
    
    weak var coverImage: UIImage?
    var themeColor: UIColor?
    
    /// # Navigation Bar
    private lazy var navigationBar: ScreenNavigationBar = {
        AnimeDetailNavigationBar(self)
    }()
    
    /// # Main collection
    private lazy var detailFeed: DetailFeed = {
        let feed = DetailFeed(presenter: presenter, animeIsPreloaded: animeIsPreLoaded)
        feed.getCollection().delegate = self
        return feed
    }()
    
    /// # Background Image
    private lazy var coverImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.image = coverImage
        coverImageContainerView.addSubview(imageView)
        return imageView
    }()
    
    private lazy var coverImageContainerView: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.clipsToBounds = true
        
        self.view.insertSubview(view, at: 0)
        return view
    }()
    
    private lazy var blurView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .systemChromeMaterial)
        let visualEffect = UIVisualEffectView(effect: blurEffect)
        visualEffect.translatesAutoresizingMaskIntoConstraints = false
        
        view.insertSubview(visualEffect, aboveSubview: coverImageContainerView)
        return visualEffect
    }()
    
    private lazy var disposeBag = DisposeBag()
    
    // MARK: Initializers
    init(presenter: AnimeDetailPresentable, animeIsPreloaded: Bool) {
        self.presenter = presenter
        self.animeIsPreLoaded = animeIsPreloaded
        
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
    
    // MARK: - Methods
    func getDetailFeed() -> DetailFeed {
        return detailFeed
    }
    
    func getBaseNavigation() -> CustomNavigationController? {
        return navigationController as? CustomNavigationController
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
        
        layoutCoverImageContainerView()
        layoutCoverImageView()
        layoutBlurView()
    }

    func bindAnime() {
        presenter?.anime
            .drive(onNext: { [weak self] (anime) in
                guard let self else { return }
                Logger.log(.info, msg: "RX DID LOAD ANIME: \(anime.titleEng)")
                
                // Cover Image.
                if (anime.imageType?.coverImage.isNil ?? true) {
                    anime.imageType?.coverImage = self.coverImage
                }
                
                // Theme Color
//                anime.imageType?.themeColor = self.themeColor
//                self.themeColor = nil
                
                self.configureNavigationTitle(with: anime.titleKanji)
                self.presenter?.updateCharacters(animeId: Int(anime.id) ?? 49387)
                self.presenter?.updateReviews(animeId: Int(anime.id) ?? 49387)
                self.presenter?.updateAnimeRecommendations(animeId: Int(anime.id) ?? 49387)
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
    
    func layoutCoverImageContainerView() {
        coverImageContainerView.fitViewTo(view)
    }
    
    func layoutCoverImageView() {
        coverImageView.fitViewTo(coverImageContainerView)
    }
    
    func layoutBlurView() {
        blurView.fitViewTo(coverImageContainerView)
    }

    func configureNavigationTitle(with title: String) {
        navigationBar.configureTitle(with: title)
    }
}

// MARK: - Delegates
extension AnimeDetailScreen: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) else { return }
        
        guard cellIsSelectable else { return }
        
        guard let content = detailFeed.getDataSource().getItem(at: indexPath) else { return }
        
        animateCellSelection(cell: cell)
        
        switch cell {
            case is RecommendedCell:
                let anime = (content as? RecommendationInfo)?.anime
                
                let image: UIImage? = (cell as? FeedCell)?.getCoverImage() ?? UIImage(named: "new-anime-item-spyxfamily")
                anime?.imageType?.coverImage = image
                if (anime?.imageType?.themeColor.isNil ?? true) {
                    anime?.imageType?.themeColor = image?.getThemeColor()
                }
                presenter?.handle(action: .transition(to: .anime(anime)))
            default: break
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) else { return }
        animateCellHighlight(cell: cell, didHighlight: true)
    }

    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) else { return }
        animateCellHighlight(cell: cell, didHighlight: false)
    }
}

// MARK: - Animations
private extension AnimeDetailScreen {
    func animateCellHighlight(cell: UICollectionViewCell, didHighlight: Bool) {
        guard checkCellIsValidForAnimation(cell: cell) else { return }
        
        UIView.animate(withDuration: 0.2) {
            cell.transform = didHighlight ? .init(scaleX: 0.95, y: 0.95) : .identity
        }
    }
    
    func animateCellSelection(cell: UICollectionViewCell) {
        guard checkCellIsValidForAnimation(cell: cell) else { return }
        
        cellIsSelectable = false
        
        cell.expand(durationInSeconds: 0.25, end: .reset, toScale: 0.95) { [weak self] in
            self?.cellIsSelectable = true
        }
    }
    
    func checkCellIsValidForAnimation(cell: UICollectionViewCell) -> Bool {
        if (cell is CharacterCell) || (cell is RecommendedCell) || (cell is ReviewCell) { return true }
        return false
    }
}
