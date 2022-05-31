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
  @IBOutlet private weak var animeCoverImage: UIImageView!
  @IBOutlet private weak var animeCoverImageContainer: UIView!
  @IBOutlet private weak var animeOnAirImage: UIImageView!
  @IBOutlet private weak var animeTitleLabel: UILabel!
  @IBOutlet private weak var animeRatingLabel: UILabel!
  @IBOutlet private weak var animeEpisodesLabel: UILabel!
  @IBOutlet private weak var animeYearLabel: UILabel!
  @IBOutlet private weak var animeSynopsisTextView: UITextView!

  @IBOutlet private weak var animeGenreCollection: UICollectionView!

  /// # Observables
  private var searchResultAnime = PublishSubject<SearchAnime>()
  private var searchResultAnimeGenre = PublishSubject<[AnimeGenre]>()
  private var disposeBag = DisposeBag()

  /// # Properties
  var anime: SearchAnime? {
    didSet {
      guard let anime = self.anime else { return }
      searchResultAnime.onNext(anime)
      searchResultAnimeGenre.onNext(anime.genres)
    }
  }
}

extension NewAnimeSearchResultItem {
  override func awakeFromNib() {
    super.awakeFromNib()
    print("awakeFromNib()")
    configureComponent()
    print("AnimeGenreCollection Height: \(animeGenreCollection.frame.size.height)")
    print("AnimeGenreCollection Width: \(animeGenreCollection.frame.size.width)")
  }
}

extension NewAnimeSearchResultItem: Component {
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
    configureGenreCollection()
    configureCellContiner()
    configureCellContiner()
    configureImages()
    configureSynopsis()
  }
}

extension NewAnimeSearchResultItem: Bindable {
  // TODO: Add missing bindings
  /// # Configure bindings (Rx)
  func configureBindings() {
    /// # animeTitleLabel (Rx)
    searchResultAnime
      .map { $0.name }
      .bind(to: animeTitleLabel.rx.text)
      .disposed(by: disposeBag)

    /// # animeSynopsisTextView (Rx)
    searchResultAnime
      .map { anime in
        let synopsis: String = anime.synopsis
        let synopsisText: String = "Synopsis: \(synopsis)"
        let attributedSynopsis: NSAttributedString = self.generateAttributedSynopsis(synopsisText)
        return attributedSynopsis
      }
      .bind(to: animeSynopsisTextView.rx.attributedText)
      .disposed(by: disposeBag)

    // TODO: SHOULD CALL VIEWMODEL METHOD
    /// # animeCoverImage (Rx)
    searchResultAnime
      .subscribe(onNext: { [weak self] anime in
        self?.animeCoverImage.imageFromBundle(imageName: anime.cover)
        print("Cover url: \(anime.cover)")
      })
      .disposed(by: disposeBag)

    /// # onAirImage (Rx)
    searchResultAnime
      .map { !$0.onAir }
      .bind(to: animeOnAirImage.rx.isHidden)
      .disposed(by: disposeBag)

    configureGenreCollectionBindings() // * review
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
  func configureCellContiner() {
    // Container shadow
    var shadow = Shadow(.bottom)
    shadow.color = Color.lightGray
    shadow.offset = CGSize(width: 2, height: 0)
    shadow.radius = 3
    animeContainerView.addShadowLayer(shadow: shadow, layerRadius: 15)
  }

  func configureImages() {
    var shadow = Shadow()
    shadow.color = Color.pink
    shadow.radius = 3
    shadow.offset = CGSize(width: -1, height: 1)
    shadow.opacity = 0.8
    animeOnAirImage.addShadowLayer(shadow: shadow, layerRadius: 0)
    animeCoverImage.addCornerRadius(radius: 15)
    animeCoverImage.layer.borderColor = Color.lightGray.withAlphaComponent(0.4).cgColor
    animeCoverImage.layer.borderWidth = 1
  }

  func configureSynopsis() {
    animeSynopsisTextView.textContainer.lineFragmentPadding = 0
    animeSynopsisTextView.textContainer.lineBreakMode = .byTruncatingTail
    animeSynopsisTextView.textContainerInset = UIEdgeInsets(top: 1, left: 0, bottom: 1, right: 0)
  }

  func generateAttributedSynopsis(_ synopsis: String) -> NSAttributedString {
    let synopsisTitleFontAttribute: UIFont = .systemFont(ofSize: 10, weight: .heavy)
    let synopsisTitleColorAttribute: UIColor = Color.gray

    let synopsisBodyFontAttribute: UIFont = .systemFont(ofSize: 10, weight: .medium)
    let synopsisBodyColorAttribute: UIColor = Color.gray

    let synopsisParagraphStyle: NSMutableParagraphStyle = .init()
    synopsisParagraphStyle.alignment = .justified

    let synopsisTitleAttributes: [NSAttributedString.Key: Any] = [
      .foregroundColor: synopsisTitleColorAttribute,
      .font: synopsisTitleFontAttribute
    ]

    let synopsisBodyAttributes: [NSAttributedString.Key: Any] = [
      .foregroundColor: synopsisBodyColorAttribute,
      .font: synopsisBodyFontAttribute
    ]

    let synopsisAttributes: [NSAttributedString.Key: Any] = [
      .paragraphStyle: synopsisParagraphStyle
    ]

    let mutableSynopsis: NSMutableAttributedString = .init(string: synopsis)
    mutableSynopsis.addAttributes(synopsisAttributes, range: NSRange(location: 0, length: synopsis.count))
    mutableSynopsis.addAttributes(synopsisTitleAttributes, range: NSRange(location: 0, length: 9))
    mutableSynopsis.addAttributes(synopsisBodyAttributes, range: NSRange(location: 10, length: synopsis.count - 10))
    return mutableSynopsis
  }
}

private extension NewAnimeSearchResultItem {
  func configureGenreCollection() {
    let cellXib = UINib(nibName: Xibs.newAnimeSearchResultGenreItemView, bundle: Bundle.main)
    let reuseIdentifier: String = Xibs.newAnimeSearchResultGenreItemView
    animeGenreCollection.register(cellXib, forCellWithReuseIdentifier: reuseIdentifier)
    animeGenreCollection.rx.setDelegate(self).disposed(by: disposeBag)
  }

  func configureGenreCollectionBindings() {
    searchResultAnimeGenre
      .bind(to: animeGenreCollection.rx.items(cellIdentifier: Xibs.newAnimeSearchResultGenreItemView, cellType: NewAnimeSearchResultGenreItem.self)) { _, genre, item in
        item.genre = genre
      }
      .disposed(by: disposeBag)
  }
}

extension NewAnimeSearchResultItem: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    // TODO: Dynamic item-width depending on label text size
    let width = animeGenreCollection.bounds.width * 0.35
    let height = animeGenreCollection.bounds.height * 1
    return CGSize(width: width, height: height)
  }

  // Set CollectionViewItem "header" (left first item padding)
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
    return .zero
  }
}
