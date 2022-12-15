//
//  HomeAnimeItem.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 1/05/22.
//

import RxSwift
import UIKit

final class HomeAnimeItem: UICollectionViewCell {
    // MARK: State
    /// # Outlets
    @IBOutlet private weak var animeCoverPicture: UIImageView!
    @IBOutlet private weak var animeCoverView: UIView!
    @IBOutlet private weak var animeTitle: UILabel!
    @IBOutlet private weak var animeContainerView: UIView!
    @IBOutlet private weak var episodeProgressBarWidthConstraint: NSLayoutConstraint!
    @IBOutlet private weak var episodeProgressBarView: UIView!

    /// # Data Source
    private var anime: Anime?

    /// # Observables
    private let disposeBag = DisposeBag()

    /// # Style
    private let cornerRadius: CGFloat = 15
    private var hasShadow: Bool = false
}

// MARK: Awake from Xib
extension HomeAnimeItem {
    override func awakeFromNib() {
        super.awakeFromNib()
        configureComponent()
    }

    override func prepareForReuse() {
        animeTitle.text = ""
        animeCoverPicture.image = nil
    }
}

// MARK: Setup cell
extension HomeAnimeItem: ComponentCollectionItem {
    func setupItem(with item: Anime) {
        self.anime = item
        animeTitle.text = item.titleEng

        // TODO: Clean this up ... add caching ...
        let httpSession = URLSession(configuration: .default)
        let imagePath: String = item.imageType.jpgImage.large
        guard let url = URL(string: imagePath) else { return }
        let httpRequest = URLRequest(url: url)
        let httpTask = httpSession.dataTask(with: httpRequest) { [weak self] data, _, error in
            guard let data = data, error == nil else { print("senku - request error : ("); return }
            DispatchQueue.main.async {
                self?.animeCoverPicture.image = UIImage(data: data)
            }
        }
        httpTask.resume()

//        configureCoverViewShadow()
        updateEpisodeProgress()
    }
}

extension HomeAnimeItem: Component {
    func configureComponent() {
        configureInitialState()
        configureView()
    }

    func configureView() {
        configureSubviews()
    }

    func configureSubviews() {
        configureContainer()
        configureCoverView()
        configureCoverImageView()
    }
}

extension HomeAnimeItem: ComponentItem {
    func configureInitialState() {
        contentView.backgroundColor = .clear
        animeCoverView.backgroundColor = .clear
    }
}

private extension HomeAnimeItem {
    func configureContainer() {
        animeContainerView.backgroundColor = Color.white
        animeContainerView.addCornerRadius(radius: cornerRadius)
    }

    func configureCoverView() {
    }

    func configureCoverImageView() {
        animeCoverPicture.addCornerRadius(radius: cornerRadius)
    }

    func configureCoverViewShadow() {
        if !hasShadow {
            animeCoverView.setNeedsLayout()
            animeCoverView.layoutIfNeeded()
            let shadow = ShadowBuilder().getTemplate(type: .bottom)
                .with(opacity: 0.25)
                .with(cornerRadius: cornerRadius)
                .build()
            animeCoverView.addShadow(with: shadow)
            hasShadow = true
        }
    }
}

extension HomeAnimeItem {
    func updateEpisodeProgress() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            UIView.animate(withDuration: 1, delay: 0.0, animations: { [weak self] in
                guard let strongSelf = self else { return }
                Constraints.updateConstraintMultiplier(&strongSelf.episodeProgressBarWidthConstraint, to: 0.8)
                strongSelf.episodeProgressBarView.superview?.layoutIfNeeded()
            })
        }
    }
}
