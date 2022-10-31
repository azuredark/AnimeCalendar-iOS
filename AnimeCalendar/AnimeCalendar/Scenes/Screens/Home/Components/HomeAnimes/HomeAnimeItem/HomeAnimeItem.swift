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
    private var anime: JikanAnime?

    /// # Observables
    private let disposeBag = DisposeBag()

    /// # Style
    private let cornerRadius: CGFloat = 15
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
    func setupItem(with item: JikanAnime) {
        self.anime = item
        animeTitle.text = item.title

        // TODO: Clean this up ... add caching ...
        let httpSession = URLSession(configuration: .default)
        let imagePath: String = item.imageType.jpgImage.normal
        print("senku [DEBUG] \(String(describing: type(of: self))) - imagePath: \(imagePath)")
        guard let url = URL(string: imagePath) else { return }
        let httpRequest = URLRequest(url: url)
        let httpTask = httpSession.dataTask(with: httpRequest) { [weak self] data, _, error in
            guard let data = data, error == nil else { print("senku - request error : ("); return }
            DispatchQueue.main.async {
                self?.animeCoverPicture.image = UIImage(data: data)
            }
        }
        httpTask.resume()

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
        configurePictureView()
        configurePictureImage()
    }
}

extension HomeAnimeItem: ComponentItem {
    func configureInitialState() {
        contentView.backgroundColor = Color.white
        animeCoverView.backgroundColor = Color.white
    }
}

extension HomeAnimeItem {
    func configurePictureView() {
        let animeCoverShadow = Shadow(.bottom)
        animeCoverView.addBottomShadow(shadow: animeCoverShadow, layerRadius: cornerRadius)
    }

    func configurePictureImage() {
        animeCoverPicture.addCornerRadius(radius: cornerRadius)
        animeContainerView.addCornerRadius(radius: cornerRadius)
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
