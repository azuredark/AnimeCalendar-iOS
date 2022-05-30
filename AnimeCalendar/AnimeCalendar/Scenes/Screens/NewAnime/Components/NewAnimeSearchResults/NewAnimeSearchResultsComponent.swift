//
//  NewAnimeSearchResults.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 23/05/22.
//

import RxCocoa
import RxSwift
import UIKit

final class NewAnimeSearchResultsComponent: UIViewController, ScreenComponent {
  /// # IBOutlets
  @IBOutlet private weak var newAnimeSearchResults: UICollectionView!
  /// # Properties
  /// # Observables
  private let animesDummy: [SearchAnime] =
    [
      SearchAnime(name: "Komi can't communicate", cover: "new-anime-item-komicantcommunicate"),
      SearchAnime(name: "Dr. Stone: Stone Wars", cover: "new-anime-item-drstone"),
      SearchAnime(name: "Spy x Family", cover: "new-anime-item-spyxfamily")
    ]
  private lazy var animesObservable: Observable<[SearchAnime]> = Observable.create { [unowned self] observer in
    observer.onNext(self.animesDummy)
    observer.onCompleted()
    return Disposables.create()
  }

  // TODO: Components should CompositeDisposable bags
  let disposeBag = DisposeBag()

  /// # Init
  init() {
    super.init(nibName: Xibs.newAnimeSearchResultsView, bundle: Bundle.main)
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

extension NewAnimeSearchResultsComponent {
  override func viewDidLoad() {
    super.viewDidLoad()
    configureComponent()
  }
}

extension NewAnimeSearchResultsComponent: Component {
  func configureComponent() {
    configureView()
    configureCollection()
    configureBindings()
  }

  func configureView() {
    // Color and radius
    view.backgroundColor = Color.white
    view.addCornerRadius(radius: 15)
    configureSubviews()
  }

  func configureSubviews() {
    // Color and radius
    newAnimeSearchResults.backgroundColor = Color.white
    newAnimeSearchResults.addCornerRadius(radius: 15)
  }
}

// TODO: Missing Contract for Collections/TableViews
extension NewAnimeSearchResultsComponent {
  func configureCollection() {
    // Register item from Xib
    let cellXib = UINib(nibName: Xibs.newAnimeSearchResultItemView, bundle: Bundle.main)
    let reuseIdentifier: String = Xibs.newAnimeSearchResultItemView

    newAnimeSearchResults.register(cellXib, forCellWithReuseIdentifier: reuseIdentifier)
    newAnimeSearchResults.rx.setDelegate(self).disposed(by: disposeBag)
  }
}

extension NewAnimeSearchResultsComponent: Bindable {
  func configureBindings() {
    animesObservable
      .bind(to: newAnimeSearchResults.rx.items(cellIdentifier: Xibs.newAnimeSearchResultItemView, cellType: NewAnimeSearchResultItem.self)) { _, anime, item in
        item.anime = anime
      }
      .disposed(by: disposeBag)
  }
}

extension NewAnimeSearchResultsComponent: UICollectionViewDelegateFlowLayout {
  // Set CollectionViewItem (HomeAnimeItem) size
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let width = newAnimeSearchResults.bounds.width * 1
    let height = newAnimeSearchResults.bounds.height * 0.45

    print("Cell width \(width)")
    print("Cell height \(height)")
    return CGSize(width: width, height: height)
  }

  // Set CollectionViewItem "header" (left first item padding)
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
    let height: Int = 5
    let width: Int = 0
    return CGSize(width: width, height: height)
  }
}
