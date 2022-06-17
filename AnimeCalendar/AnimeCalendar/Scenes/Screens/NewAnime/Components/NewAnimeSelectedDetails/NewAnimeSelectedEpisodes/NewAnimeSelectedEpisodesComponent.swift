//
//  NewAnimeSelectedEpisodesComponent.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 16/06/22.
//

import UIKit

final class NewAnimeSelectedEpisodesComponent: UIViewController, ScreenComponent {
  /// # Properties
  /// # Init
  init() {
    super.init(nibName: Xibs.newAnimeSelectedEpisodesComponentView, bundle: Bundle.main)
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

extension NewAnimeSelectedEpisodesComponent {
  override func viewDidLoad() {
    super.viewDidLoad()
  }
}

extension NewAnimeSelectedEpisodesComponent: Component {
  func configureComponent() {}

  func configureView() {}

  func configureSubviews() {}
}
