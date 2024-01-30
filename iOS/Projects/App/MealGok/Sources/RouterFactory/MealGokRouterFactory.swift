//
//  MealGokRouterFactory.swift
//  MealGok
//
//  Created by MaraMincho on 1/30/24.
//  Copyright © 2024 com.maramincho. All rights reserved.
//

import RouterFactory
import UIKit

final class MealGokRouterFactory: RouteFactoriable {
  var parentRouter: Routing?

  var navigationController: UINavigationController?

  var childRouters: [Routing] = []

  func start(window: UIWindow?) {
    let build = build()
    window?.rootViewController = build
    start(build: build)
    window?.makeKeyAndVisible()
  }

  /// can not use this method directly.
  /// if app start, must set RootViewController and Window.
  /// So use method "start(window:)"
  func start(build: UIViewController) {
    guard let build = build as? UINavigationController else {
      return
    }
    navigationController = build

    let tabBarRouterFactory = TabBarRouteFactory(parentRouter: self, navigationController: build)
    tabBarRouterFactory.start(build: tabBarRouterFactory.build())
  }

  func build() -> UIViewController {
    return UINavigationController()
  }
}
