//
//  TabBarRouteFactory.swift
//  RouteFactory
//
//  Created by MaraMincho on 1/30/24.
//  Copyright © 2024 com.maramincho. All rights reserved.
//

import DesignSystem
import MealTimerFeature
import OSLog
import RouterFactory
import UIKit
import ProfileFeature

// MARK: - TabBarRouteFactory

public final class TabBarRouteFactory: RouterFactoriable {
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
    tabBarController.tabBar.tintColor = DesignSystemColor.main01

    return tabBarController
  }

  private func buildTabBarComponent() -> [UIViewController] {
    let contents = TabBarScreenType.allCases.compactMap {type -> UIViewController? in
      return makeRouter(type: type)
    }
    return contents
  }
  
  private func makeRouter(type: TabBarScreenType) -> UIViewController {
    switch type {
    case .timer:
      let mealTimerRouterFactory = MealGokHomeRouterFactory(self, navigationController: navigationController)
      childRouters.append(mealTimerRouterFactory)
      let vc = mealTimerRouterFactory.build()
      vc.title = type.title
      vc.tabBarItem.image = type.image
      return vc
    case .profile:
      let profileRouterFactory = ProfileSceneRouterFactory(parentRouter: self, navigationController: navigationController)
      childRouters.append(profileRouterFactory)
      let vc = profileRouterFactory.build()
      vc.title = type.title
      vc.tabBarItem.image = type.image
      return vc
    }
  }

  // MARK: - TabBarScreenType

  private enum TabBarScreenType: CaseIterable {
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
  }
}
