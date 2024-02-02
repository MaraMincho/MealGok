//
//  MealGokSuccessSceneRouterFactory.swift
//  MealTimerFeature
//
//  Created by MaraMincho on 2/1/24.
//  Copyright © 2024 com.maramincho. All rights reserved.
//

import RouterFactory
import UIKit

// MARK: - MealGokSuccessSceneRouter

protocol MealGokSuccessSceneRouter: Routing {
  func goHome()
}

// MARK: - MealGokSuccessSceneRouterFactory

final class MealGokSuccessSceneRouterFactory: RouterFactoriable {
  weak var parentRouter: Routing?

  weak var navigationController: UINavigationController?

  var childRouters: [Routing] = []

  init(router: Routing, navigationController: UINavigationController?) {
    parentRouter = router
    self.navigationController = navigationController
  }

  func start(build: UIViewController) {
    navigationController?.pushViewController(build, animated: true)
  }

  func build() -> UIViewController {
    let viewModel = MealGokSuccessSceneViewModel()
    viewModel.router = self

    let viewController = MealGokSuccessSceneViewController(viewModel: viewModel)
    return viewController
  }
}

// MARK: MealGokSuccessSceneRouter

extension MealGokSuccessSceneRouterFactory: MealGokSuccessSceneRouter {
  func goHome() {
    NotificationCenter.default.post(name: .goHomeAndReBuild, object: nil)
  }
}
