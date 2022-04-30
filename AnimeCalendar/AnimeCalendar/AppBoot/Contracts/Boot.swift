//
//  BootProduct.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 24/04/22.
//

import UIKit.UIViewController

protocol Boot {
  var requestsManager: RequestProtocol { get set }
  var rootVC: ScreenProtocol { get set }
  func createRootScreen() -> UITabBarController
}
