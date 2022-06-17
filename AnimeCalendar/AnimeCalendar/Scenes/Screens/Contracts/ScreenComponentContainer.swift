//
//  ScreenComponentContainer.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 16/06/22.
//

import UIKit.UIViewController

protocol ScreenComponentContainer: UIViewController & Component {
  var components: [ScreenComponent] { get set }
  func configureChildComponents(_ children: [ScreenComponent])
}
