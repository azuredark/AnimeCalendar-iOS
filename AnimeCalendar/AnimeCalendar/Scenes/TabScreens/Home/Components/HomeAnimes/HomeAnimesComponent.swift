//
//  HomeAnimesComponent.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 1/05/22.
//

import RxCocoa
import RxSwift
import UIKit

/// # Home animes collection
final class HomeAnimesComponent: UIViewController {
  /// # Outlets
  @IBOutlet private weak var animesCollection: UICollectionView!

  /// # Observables
  let animesDummy: [HomeAnime] =
    [
      HomeAnime(name: "Spy x Family", cover: "www"),
      HomeAnime(name: "Dr. Stone", cover: "www"),
    ]
  lazy var animesObservable: Observable<[HomeAnime]> = Observable.create { [unowned self] observer in
    observer.onNext(self.animesDummy)
    observer.onCompleted()
    return Disposables.create()
  }

  let disposeBag = DisposeBag()

  init() {
    super.init(nibName: Xibs.homeAnimesComponentView, bundle: Bundle.main)
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

extension HomeAnimesComponent {
  override func viewDidLoad() {
    super.viewDidLoad()
    configureView()
  }
}

extension HomeAnimesComponent: ScreenComponent {
  func configureView() {
    configureCollection()
    bindCollection()
    configureSubviews()
  }

  func configureSubviews() {}
}

extension HomeAnimesComponent: UICollectionViewDelegateFlowLayout {
  func configureCollection() {
    // Register item from Xib
    animesCollection.register(UINib(nibName: Xibs.homeAnimeItemView, bundle: Bundle.main), forCellWithReuseIdentifier: Xibs.homeAnimeItemView)
    // Set delegate
    animesCollection.rx.setDelegate(self).disposed(by: disposeBag)
  }

  func bindCollection() {
    animesObservable
      .bind(to: animesCollection.rx.items(cellIdentifier: Xibs.homeAnimeItemView, cellType: HomeAnimeItem.self)) { _, anime, item in
        item.anime = anime
      }
      .disposed(by: disposeBag)
  }

  // Set CollectionViewItem (HomeAnimeItem) size
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    print("ITEM SIZE")
    return CGSize(width: animesCollection.bounds.width * 0.7, height: animesCollection.bounds.height * 1)
  }

  // Set CollectionViewItem "header" (left first item padding)
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
    return CGSize(width: 15, height: 0)
  }
}
