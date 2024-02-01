//
//  TabBarRouteFactory.swift
//  RouteFactory
//
//  Created by MaraMincho on 1/30/24.
//  Copyright © 2024 com.maramincho. All rights reserved.
//

import DesignSystem
import MealTimerFeature
import RouterFactory
import UIKit

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
    let contents = TabBarScreenType.allCases.map { type in
      let nav = UINavigationController()
      nav.title = type.title
      nav.tabBarItem.image = type.image
      type.startTabBarContentViewController(self, navigationController: nav)

      return nav
    }
    return contents
  }

  deinit {
    print("깨꼬닥")
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

  func startTabBarContentViewController(_ router: Routing, navigationController: UINavigationController) {
    switch self {
    case .timer:
      let mealTimerRouterFactory = MealTimerSceneRouterFactory(router, navigationController: navigationController)
      router.childRouters.append(mealTimerRouterFactory)
      mealTimerRouterFactory.start(build: mealTimerRouterFactory.build())
    case .profile:
      let vc = UIViewController()
      navigationController.setViewControllers([vc], animated: true)
    }
  }
}
