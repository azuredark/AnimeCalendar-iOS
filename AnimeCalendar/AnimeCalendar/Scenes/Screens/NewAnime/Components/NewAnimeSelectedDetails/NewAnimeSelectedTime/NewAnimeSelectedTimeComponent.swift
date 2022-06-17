//
//  NewAnimeSelectedTimeComponent.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 16/06/22.
//

import UIKit

final class NewAnimeSelectedTimeComponent: UIViewController, ScreenComponent {
  /// # Properties
  /// # Init
  init() {
    super.init(nibName: Xibs.newAnimeSelectedTimeComponentView, bundle: Bundle.main)
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

extension NewAnimeSelectedTimeComponent {
  override func viewDidLoad() {
    super.viewDidLoad()
  }
}

extension NewAnimeSelectedTimeComponent: Component {
  func configureComponent() {}

  func configureView() {}

  func configureSubviews() {}
}
