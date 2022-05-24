//
//  NewAnimeSearchResults.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 23/05/22.
//

import UIKit

final class NewAnimeSearchResults: UIViewController {
  /// # IBOutlets
  /// # Properties
  /// # Init
  init() {
    super.init(nibName: Xibs.newAnimeSearchResultsView, bundle: Bundle.main)
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

extension NewAnimeSearchResults {
  override func viewDidLoad() {
    super.viewDidLoad()
    configureComponent()
  }
}

extension NewAnimeSearchResults {
  func configureComponent() {
    configureView()
    configureSubviews()
  }
}

extension NewAnimeSearchResults: ScreenComponent {
  func configureView() {}

  func configureSubviews() {}
}

extension NewAnimeSearchResults {}
