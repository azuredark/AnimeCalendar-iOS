//
//  NewAnimeSearchResultGenreItem.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 29/05/22.
//

import RxCocoa
import RxSwift
import UIKit

final class NewAnimeSearchResultGenreItem: UICollectionViewCell, ComponentCollectionItem {
  /// # Outlets
  @IBOutlet private weak var genreLabel: UILabel!
  @IBOutlet private weak var genreView: UIView!

  /// # Observables
  private var animeGenre = PublishSubject<AnimeGenre>()
  private var disposeBag = DisposeBag()
  /// # Properties
  var genre: AnimeGenre? {
    didSet {
      guard let genre = self.genre else { return }
      print("genre didSet: \(genre.name)")
      animeGenre.onNext(genre)
    }
  }

  override func awakeFromNib() {
    super.awakeFromNib()
    print("\(self) awakeFromNib()")
    configureComponent()
  }
}

extension NewAnimeSearchResultGenreItem: Component {
  /// # Collection item
  func configureComponent() {
    configureBindings()
    configureInitialState()
    configureView()
  }

  /// # Configure View
  func configureView() {
    configureSubviews()
  }

  /// # Configure Subviews
  func configureSubviews() {
    genreView.addCornerRadius(radius: 5)
  }
}

extension NewAnimeSearchResultGenreItem: Bindable {
  /// # Configure bindings (Rx)
  func configureBindings() {
    animeGenre
      .map { $0.name }
      .bind(to: genreLabel.rx.text)
      .disposed(by: disposeBag)
  }
}

extension NewAnimeSearchResultGenreItem: ComponentItem {
  /// # Initial state
  func configureInitialState() {
    genreLabel.text = "ANIME_GENRE"
    genreView.backgroundColor = Color.cobalt
  }
}
