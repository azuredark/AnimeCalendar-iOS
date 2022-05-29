//
//  NewAnimeSearchResultItem.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 27/05/22.
//

import RxCocoa
import RxSwift
import UIKit

final class NewAnimeSearchResultItem: UICollectionViewCell, ComponentCollectionItem {
  /// # Outlets
  @IBOutlet private weak var animeContainerView: UIView!
  @IBOutlet private weak var animeTitleLabel: UILabel!
  @IBOutlet private weak var animeCoverImage: UIImageView!
  @IBOutlet private weak var animeGenreCollection: UICollectionView!

  /// # Observables
  var searchResultAnime: BehaviorSubject<HomeAnime>?
  private var disposeBag = DisposeBag()

  /// # Properties
  var anime: HomeAnime? {
    didSet {
      guard let anime = self.anime else { return }
      searchResultAnime = BehaviorSubject(value: anime)
      configureBindings()
    }
  }
}

extension NewAnimeSearchResultItem {
  override func awakeFromNib() {
    super.awakeFromNib()
    configureComponent()
  }
}

extension NewAnimeSearchResultItem: Component {
  /// # Collection item
  func configureComponent() {
    configureInitialState()
    configureView()
  }

  /// # Configure View
  func configureView() {
    configureSubviews()
  }

  /// # Configure Subviews
  func configureSubviews() {
    configureShadows()
    configureImages()
  }
}

extension NewAnimeSearchResultItem: Bindable {
  /// # Configure bindings (Rx)
  func configureBindings() {
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
}

extension NewAnimeSearchResultItem: ComponentItem {
  /// # Initial values
  func configureInitialState() {
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
