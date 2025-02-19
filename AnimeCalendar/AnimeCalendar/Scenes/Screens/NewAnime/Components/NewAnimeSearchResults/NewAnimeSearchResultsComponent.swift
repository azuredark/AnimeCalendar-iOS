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
    // MARK: State
    /// # IBOutlets
    @IBOutlet private weak var newAnimeSearchResults: UICollectionView!

    /// # Presenter
    private weak var presenter: NewAnimePresentable?

    /// # Observables
    let disposeBag = DisposeBag()

    /// # Init
    init(presenter: NewAnimePresentable?) {
        super.init(nibName: Xibs.newAnimeSearchResultsView, bundle: Bundle.main)
        self.presenter = presenter
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
        guard let presenter = presenter else { return }
        presenter.searchAnimeResult
            .drive(newAnimeSearchResults.rx.items(cellIdentifier: Xibs.newAnimeSearchResultItemView, cellType: NewAnimeSearchResultItem.self)) { [weak presenter] _, anime, item in
                guard let presenter = presenter else { return }
                item.presenter = presenter
                item.setupItem(with: anime)
            }
            .disposed(by: disposeBag)

//        presenter?.searchAnimeResult
//            .drive(onNext: { [weak self] _ in
//                guard let strongSelf = self else { return }
//                UIView.animate(withDuration: 0.2, delay: .zero) {
//                    strongSelf.newAnimeSearchResults.contentOffset = .zero
//                }
//            }).disposed(by: disposeBag)
    }
}

extension NewAnimeSearchResultsComponent: UICollectionViewDelegateFlowLayout {
    // Set CollectionViewItem (HomeAnimeItem) size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = newAnimeSearchResults.bounds.width * 1
//    let height = newAnimeSearchResults.bounds.height * 0.45 ** iPhone 11
        let height = newAnimeSearchResults.bounds.height * 0.55

        return CGSize(width: width, height: height)
    }

    // Set CollectionViewItem "header" (left first item padding)
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let height: Int = 5
        let width: Int = 0
        return CGSize(width: width, height: height)
    }
}

extension NewAnimeSearchResultsComponent {
    func resetCollectionOffset() {
        newAnimeSearchResults.contentOffset = .zero
    }
}
