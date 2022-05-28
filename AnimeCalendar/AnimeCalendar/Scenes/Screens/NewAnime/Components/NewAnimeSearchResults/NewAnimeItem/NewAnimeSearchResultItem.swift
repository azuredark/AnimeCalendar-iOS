//
//  NewAnimeSearchResultItem.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 27/05/22.
//

import RxCocoa
import RxSwift
import UIKit

final class NewAnimeSearchResultItem: UICollectionViewCell {
  /// # Outlets
  @IBOutlet private weak var animeContainerView: UIView!
  @IBOutlet private weak var animeTitleLabel: UILabel!
  @IBOutlet private weak var animeCoverImage: UIImageView!
  /// # Observables
  var searchResultAnime: BehaviorSubject<HomeAnime>?
  private var disposeBag = DisposeBag()
  /// # Properties
  var anime: HomeAnime? {
    didSet {
      guard let anime = self.anime else { return }
      searchResultAnime = BehaviorSubject(value: anime)
      configureCollectionItemBindings()
    }
  }
}

extension NewAnimeSearchResultItem {
  override func awakeFromNib() {
    super.awakeFromNib()
    configureCollectionItem()
  }
}

extension NewAnimeSearchResultItem: ComponentCollectionItem {
  /// # Collection item
  func configureCollectionItem() {
    configureView()
  }

  /// # Configure bindings (Rx)
  func configureCollectionItemBindings() {
    searchResultAnime?
      .map { $0.name }
      .bind(to: animeTitleLabel.rx.text)
      .disposed(by: disposeBag)

    // TODO: SHOULD CALL VIEWMODEL METHOD
    searchResultAnime?
      .subscribe(onNext: { [weak self] anime in
        self?.animeCoverImage.imageFromBundle(imageName: anime.cover)
        print("Cover url: \(anime.cover)")
      })
      .disposed(by: disposeBag)
  }

  /// # Configure View
  func configureView() {
    configureInitialValues()
    configureSubViews()
  }

  /// # Configure Subviews
  func configureSubViews() {
    configureShadows()
    configureImages()
  }

  /// # Initial values
  func configureInitialValues() {
    // Container and contentView background colors
    contentView.backgroundColor = Color.white
    animeContainerView.backgroundColor = Color.white

    // Values
    animeTitleLabel.text = nil
  }
}

private extension NewAnimeSearchResultItem {
  func configureShadows() {
    // Container shadow
    var shadow = Shadow(.bottom)
    shadow.color = Color.lightGray
    shadow.offset = CGSize(width: 2, height: 0)
    shadow.radius = 2
    animeContainerView.addShadowLayer(shadow: shadow, layerRadius: 15)
  }

  func configureImages() {
    animeCoverImage.addCornerRadius(radius: 15)
    animeCoverImage.layer.borderColor = Color.lightGray.withAlphaComponent(0.4).cgColor
    animeCoverImage.layer.borderWidth = 1
  }
}
