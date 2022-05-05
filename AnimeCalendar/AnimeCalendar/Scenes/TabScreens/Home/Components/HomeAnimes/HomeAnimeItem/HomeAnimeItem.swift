//
//  HomeAnimeItem.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 1/05/22.
//

import RxSwift
import UIKit

final class HomeAnimeItem: UICollectionViewCell {
  /// # Outlets
  @IBOutlet private weak var animeCoverPicture: UIImageView!
  @IBOutlet private weak var animeCoverView: UIView!
  @IBOutlet private weak var animeContainerView: UIView!
  @IBOutlet private weak var episodeProgressBarWidthConstraint: NSLayoutConstraint!
  @IBOutlet private weak var episodeProgressBarView: UIView!

  var anime: HomeAnime? {
    didSet {
      print("Anime didSet")
      updateEpisodeProgress()
    }
  }

  var componentDidAppear: BehaviorSubject<Bool>? {
    didSet {
//      print("Component didSset")
    }
  }

  lazy var disposeBag = DisposeBag()

  private let cornerRadius: CGFloat = 15
}

extension HomeAnimeItem {
  override func awakeFromNib() {
    super.awakeFromNib()
    configureCollectionItem()
    print("Configured Item")
  }
}

// TODO: Create abstraction for CollectionItem
extension HomeAnimeItem {
  func configureCollectionItem() {
//    configureBindings()
    configurePictureView()
    configurePictureImage()
//    updateEpisodeProgress()
  }

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

private extension HomeAnimeItem {
  // TODO: FIX BINDINGS, THIS SHOULD ONLY BE RAN ONCE DURING AWAKE-FROM-NIB
  func configureBindings() {
    componentDidAppear?
      .ifEmpty(default: false)
      .asObservable()
      .subscribe(onNext: { [weak self] value in
        if value {
          self?.updateEpisodeProgress()
        }
      })
      .disposed(by: disposeBag)
  }
}
