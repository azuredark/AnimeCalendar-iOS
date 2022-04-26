//
//  DevelopBoot.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 24/04/22.
//

import Foundation
import UIKit.UIViewController

final class DevelopBoot: Boot {
  internal lazy var requestsManager: RequestProtocol = RequestsManager()
  internal lazy var rootVC: ScreenProtocol = HomeScreenVC(requestsManager: requestsManager)

  func createRootScreen() -> UIViewController {
    let wrapper = RootScreenWrapper(rootVC: rootVC)
    let wrappedVC = wrapper.wrapRootVC()
    return wrappedVC
  }
}
