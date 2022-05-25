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
    configureView()
  }
}

extension NewAnimeSearchBarComponent: ScreenComponent {
  func configureView() {
    newAnimeSearchBar.placeholder = "shingeki no kyojin, dr. stone"
  }

  func configureSubviews() {}
}
