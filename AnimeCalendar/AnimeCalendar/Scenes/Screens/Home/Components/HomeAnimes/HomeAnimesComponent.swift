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
final class HomeAnimesComponent: UIViewController, ScreenComponent {
  /// # Outlets
  @IBOutlet private weak var animesCollection: UICollectionView!

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

  // Flag to pass for the AnimateItem
  let componentDidAppear: BehaviorSubject<Bool> = BehaviorSubject(value: false)

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
    configureComponent()
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    componentDidAppear.onNext(true)
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    componentDidAppear.onNext(false)
  }
}

extension HomeAnimesComponent: Component {
  func configureComponent() {
    configureView()
    configureCollection()
    configureBindings()
  }

  func configureView() {
    configureSubviews()
  }

  func configureSubviews() {}
}

extension HomeAnimesComponent {
  func configureCollection() {
    // Register item from Xib
    animesCollection.register(UINib(nibName: Xibs.homeAnimeItemView, bundle: Bundle.main), forCellWithReuseIdentifier: Xibs.homeAnimeItemView)
    // Set delegate
    animesCollection.rx.setDelegate(self).disposed(by: disposeBag)
  }
}

extension HomeAnimesComponent: Bindable {
  func configureBindings() {
    animesObservable
      .bind(to: animesCollection.rx.items(cellIdentifier: Xibs.homeAnimeItemView, cellType: HomeAnimeItem.self)) { [weak self] _, anime, item in
        item.anime = anime
        item.componentDidAppear = self?.componentDidAppear
      }
      .disposed(by: disposeBag)
  }
}

extension HomeAnimesComponent: UICollectionViewDelegateFlowLayout {
  // Set CollectionViewItem (HomeAnimeItem) size
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let width = animesCollection.bounds.width * 0.7
    let height = animesCollection.bounds.height * 1
    return CGSize(width: width, height: height)
  }

  // Set CollectionViewItem "header" (left first item padding)
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
    let height: Int = 0
    let width: Int = 15
    return CGSize(width: width, height: height)
  }
}
