//
//  MealGokRouterFactory.swift
//  MealGok
//
//  Created by MaraMincho on 1/30/24.
//  Copyright © 2024 com.maramincho. All rights reserved.
//

import RouterFactory
import SharedNotificationName
import UIKit

// MARK: - MealGokRouterFactory

final class MealGokRouterFactory: RouterFactoriable {
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
    childRouters.append(tabBarRouterFactory)
    tabBarRouterFactory.start(build: tabBarRouterFactory.build())
  }

  func build() -> UIViewController {
    let navigationController = UINavigationController()
    navigationController.navigationBar.isHidden = true
    return navigationController
  }

  init() {
    observeNotification()
  }
}

// MARK: MealGokRouterFactory apply NotificationCenter

extension MealGokRouterFactory {
  func observeNotification() {
    // GoHome NotificationCenter
    NotificationCenter.default.addObserver(forName: .goHome, object: nil, queue: .main) { [weak self] _ in
      guard let self else { return }
      let tapBarRouter = childRouters[0]
      tapBarRouter.childRouters.forEach { $0.childRouters = [] }
      navigationController?.popToRootViewController(animated: true)
    }

    // GoHomeAndReBuild NotificationCenter
    NotificationCenter.default.addObserver(forName: .goHomeAndReBuild, object: nil, queue: .main) { [weak self] _ in
      guard let self else { return }
      popRouter()
      guard let navigationController else {
        return
      }
      start(build: navigationController)
    }
  }
}
