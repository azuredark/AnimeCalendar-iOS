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

    // TODO: Add differente animes to the sequence (With bindings) so it can simulate managing data from the Network Provider
    var animes: [Anime] = []
    private let animesDriver: Driver<[Anime]>

    // Flag to pass for the AnimateItem
    let componentDidAppear: BehaviorSubject<Bool> = BehaviorSubject(value: false)

    let disposeBag = DisposeBag()

    init(animes: Driver<[Anime]>) {
        self.animesDriver = animes
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
        configureBindings()
        configureView()
        configureCollection()
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
        // Set delegate & data source
        animesCollection.dataSource = self
        animesCollection.delegate = self
    }
}

extension HomeAnimesComponent: Bindable {
    func configureBindings() {
        animesDriver
            .drive(onNext: { [weak self] animes in
                guard let strongSelf = self else { return }
                strongSelf.animes = animes
                strongSelf.animesCollection.reloadData()
            }).disposed(by: disposeBag)
    }
}

// MARK: CollectionView Delegate
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

// MARK: CollectionView DataSource
extension HomeAnimesComponent: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("senku [DEBUG] \(String(describing: type(of: self))) - numberOfItemsInSection: \(animes.count)")
        return animes.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Xibs.homeAnimeItemView, for: indexPath) as? HomeAnimeItem else {
            fatalError("ACError - [HomeAnimesComponent] Error dequeing cell")
        }
        let anime: Anime = animes[indexPath.item]
        cell.setupItem(with: anime)
        return cell
    }
}
