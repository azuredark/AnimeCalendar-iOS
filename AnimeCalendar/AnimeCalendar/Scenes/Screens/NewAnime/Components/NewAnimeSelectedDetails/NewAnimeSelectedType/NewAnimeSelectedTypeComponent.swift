//
//  NewAnimeSelectedTypeComponent.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 16/06/22.
//

import UIKit

final class NewAnimeSelectedTypeComponent: UIViewController, ScreenComponent {
  /// # Properties
  /// # Init
  init() {
    super.init(nibName: Xibs.newAnimeSelectedTypeComponentView, bundle: Bundle.main)
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

extension NewAnimeSelectedTypeComponent {
  override func viewDidLoad() {
    super.viewDidLoad()
  }
}

extension NewAnimeSelectedTypeComponent: Component {
  func configureComponent() {}

  func configureView() {}

  func configureSubviews() {}
}
