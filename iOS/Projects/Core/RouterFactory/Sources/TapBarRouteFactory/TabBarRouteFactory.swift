//
//  TabBarRouteFactory.swift
//  RouteFactory
//
//  Created by MaraMincho on 1/30/24.
//  Copyright © 2024 com.maramincho. All rights reserved.
//

import UIKit

// MARK: - TabBarRouteFactory

public final class TabBarRouteFactory: RouteFactoriable {
  public init(parentRouter: Routing, navigationController: UINavigationController) {
    self.parentRouter = parentRouter
    self.navigationController = navigationController
  }

  public weak var parentRouter: Routing?

  public var navigationController: UINavigationController?

  public var childRouters: [Routing] = []

  public func start(build: UIViewController) {
    navigationController?.setViewControllers([build], animated: false)
  }

  public func build() -> UIViewController {
    let tabBarController = UITabBarController()
    tabBarController.setViewControllers(buildTabBarComponent(), animated: false)

    return tabBarController
  }

  private func buildTabBarComponent() -> [UIViewController] {
    let contents = TabBarScreenType.allCases.map { type in
      let nav = UINavigationController(rootViewController: type.viewController)
      nav.title = type.title
      nav.tabBarItem.image = type.image

      return nav
    }
    return contents
  }
}

// MARK: - TabBarScreenType

enum TabBarScreenType: CaseIterable {
  case timer
  case profile

  var image: UIImage? {
    switch self {
    case .timer:
      return UIImage(systemName: "fork.knife.circle")
    case .profile:
      return UIImage(systemName: "person.crop.circle")
    }
  }

  var title: String {
    switch self {
    case .timer:
      return "타이머"
    case .profile:
      return "프로필"
    }
  }

  var viewController: UIViewController {
    switch self {
    case .timer:
      let vc = UIViewController()
      vc.view.backgroundColor = .blue
      return vc
    case .profile:
      let vc = UIViewController()
      vc.view.backgroundColor = .cyan
      return vc
    }
  }
}
