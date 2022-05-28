//
//  SearchBarComponent.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 19/05/22.
//

import UIKit

final class NewAnimeSearchBarComponent: UIViewController {
  /// # Outlets
  @IBOutlet private weak var newAnimeSearchBar: UISearchBar!
  /// # Properties
  /// # Observables

  /// # Init
  init() {
    super.init(nibName: Xibs.newAnimeSearchBarView, bundle: Bundle.main)
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

extension NewAnimeSearchBarComponent: ScreenComponent {
  func configureComponent() {
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
