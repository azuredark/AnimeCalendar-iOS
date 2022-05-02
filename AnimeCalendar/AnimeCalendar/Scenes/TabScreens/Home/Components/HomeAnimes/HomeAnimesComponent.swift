//
//  HomeAnimesComponent.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 1/05/22.
//

import RxCocoa
import RxSwift
import UIKit

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

private extension HomeAnimesComponent {
  func configureCollection() {
    animesCollection.register(UINib(nibName: Xibs.homeAnimeItemView, bundle: Bundle.main), forCellWithReuseIdentifier: Xibs.homeAnimeItemView)
  }

  func bindCollection() {
    animesObservable
      .bind(to: animesCollection.rx.items(cellIdentifier: Xibs.homeAnimeItemView, cellType: HomeAnimeItem.self)) { _, anime, item in
        item.anime = anime
      }
      .disposed(by: disposeBag)
  }
}
