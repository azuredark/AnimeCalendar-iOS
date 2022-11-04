//
//  SearchBarComponent.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 19/05/22.
//

import UIKit
import RxSwift
import RxCocoa

final class NewAnimeSearchBarComponent: UIViewController, ScreenComponent {
    /// # Outlets
    @IBOutlet private weak var newAnimeSearchBar: UISearchBar!

    /// # Properties
    private weak var presenter: NewAnimePresentable?

    private let disposeBag = DisposeBag()

    /// # Init
    init(presenter: NewAnimePresentable?) {
        super.init(nibName: Xibs.newAnimeSearchBarView, bundle: Bundle.main)
        self.presenter = presenter
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension NewAnimeSearchBarComponent {
    override func viewDidLoad() {
        super.viewDidLoad()
        configureComponent()
    }
}

extension NewAnimeSearchBarComponent: Component {
    func configureComponent() {
        configureBindings()
        configureView()
    }

    // TODO: Searchbar background color changes in DarkMode
    // TODO: Searchbar background color is NOT fully Color.white
    func configureView() {
        newAnimeSearchBar.searchBarStyle = .minimal
        newAnimeSearchBar.autocapitalizationType = .none
        newAnimeSearchBar.placeholder = "shingeki no kyojin, dr. stone"
        newAnimeSearchBar.searchTextField.backgroundColor = Color.white
        newAnimeSearchBar.searchTextField.isOpaque = true
        newAnimeSearchBar.searchTextField.layer.opacity = 1
        newAnimeSearchBar.searchTextField.font = UIFont.boldSystemFont(ofSize: 16)
        newAnimeSearchBar.searchTextField.textColor = Color.cobalt
        newAnimeSearchBar.searchTextField.leftView?.tintColor = Color.cobalt
    }

    func configureSubviews() {}
}

extension NewAnimeSearchBarComponent: Bindable {
    func configureBindings() {
        bindSearchResult()
        bindSearchBar()
    }

    func bindSearchBar() {
        guard let presenter = presenter else { return }
        newAnimeSearchBar.rx.text
            .orEmpty
            .filter { !$0.isEmpty && $0.count > 2 }
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .bind(to: presenter.searchInput)
            .disposed(by: disposeBag)
        
        newAnimeSearchBar.rx.textDidEndEditing
            .subscribe(onNext: { a in
               print("senku [DEBUG] \(String(describing: type(of: self))) - END EDITTINGGG!!! ")
            }).disposed(by: disposeBag)
        
        
    }
    
    func bindSearchResult() {
        presenter?.searchAnimeResult
            .drive(onNext: { animes in
                print("senku [DEBUG] \(String(describing: type(of: self))) - animes found: \(animes.map {$0.title})")
            })
            .disposed(by: disposeBag)
    }
}
