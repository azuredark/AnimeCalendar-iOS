//
//  CustomTabBarController.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 5/05/22.
//

import UIKit

final class CustomTabBarController: UITabBarController {
  /// # Overriding properties
  var middleButton = UIButton()

  init() {
    super.init(nibName: nil, bundle: nil)
    configureTabBar()
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

extension CustomTabBarController: TabBarProtocol {
  func configureTabBar() {
    tabBar.backgroundColor = Color.white
    tabBar.unselectedItemTintColor = Color.lightGray
    tabBar.tintColor = Color.cobalt

    // TODO: MODULARIZE, CLEAN
    /// # Custom TabBar Button
    middleButton = UIButton()

    middleButton.frame.size = CGSize(width: 48, height: 48)

    let image = UIImage(systemName: "plus")!
    middleButton.setImage(image, for: .normal)
    middleButton.backgroundColor = Color.pink
    middleButton.tintColor = .white
//    middleButton.layer.cornerRadius = 23
    
    var shadow = Shadow()
    shadow.color = Color.pink
    shadow.radius = 10
    middleButton.addShadowLayer(shadow: shadow, layerRadius: 23)
    tabBar.addSubview(middleButton)
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    print("DID AWAKE FROM NIB")
  }

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    middleButton.center = CGPoint(x: self.tabBar.frame.width / 2, y: -5)
  }
}
