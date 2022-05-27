//
//  NewAnimeSearchResults.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 23/05/22.
//

import RxCocoa
import RxSwift
import UIKit

final class NewAnimeSearchResultsComponent: UIViewController {
  /// # IBOutlets
  @IBOutlet private weak var newAnimeSearchResults: UICollectionView!
  /// # Properties
  /// # Observables
  private let animesDummy: [HomeAnime] =
    [
      HomeAnime(name: "Spy x Family", cover: "www"),
      HomeAnime(name: "Dr. Stone", cover: "www"),
    ]
  private lazy var animesObservable: Observable<[HomeAnime]> = Observable.create { [unowned self] observer in
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

extension NewAnimeSearchResultsComponent: ScreenComponent {
  func configureComponent() {
    configureView()
    configureCollection()
    bindCollection()
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

extension NewAnimeSearchResultsComponent: ComponentCollection {
  func configureCollection() {
    // Register item from Xib
    newAnimeSearchResults.register(UINib(nibName: Xibs.newAnimeSearchResultItemView, bundle: Bundle.main), forCellWithReuseIdentifier: Xibs.newAnimeSearchResultItemView)
    // Set delegate
    newAnimeSearchResults.rx.setDelegate(self).disposed(by: disposeBag)
  }

  func bindCollection() {
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
    let width = newAnimeSearchResults.bounds.width * 0.90
    let height = newAnimeSearchResults.bounds.height * 0.5

    print("Cell width \(width)")
    print("Cell height \(height)")
    return CGSize(width: width, height: height)
  }

  // Set CollectionViewItem "header" (left first item padding)
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
    let height: Int = 15
    let width: Int = 0
    return CGSize(width: width, height: height)
  }
}
