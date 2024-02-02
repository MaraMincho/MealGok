//
//  StartMealTimerSceneRouterFactory.swift
//  MealTimerFeature
//
//  Created by MaraMincho on 1/31/24.
//  Copyright © 2024 com.maramincho. All rights reserved.
//

import RouterFactory
import UIKit

// MARK: - StartMealTimerSceneRouterFactoriable

protocol StartMealTimerSceneRouterFactoriable: RouterFactoriable {
  func pushSuccessScene()
}

// MARK: - StartMealTimerSceneRouterFactory

final class StartMealTimerSceneRouterFactory: RouterFactoriable {
  weak var parentRouter: Routing?

  weak var navigationController: UINavigationController?

  var childRouters: [Routing] = []

  func start(build: UIViewController) {
    navigationController?.pushViewController(build, animated: false)
  }

  func build() -> UIViewController {
    let customStringFormatter = CustomTimeStringFormatter(minutes: 0, seconds: 5, totalUpdateCount: 480)
    let timerUseCase = TimerUseCase(customStringFormatter: customStringFormatter)

    let viewModel = TimerSceneViewModel(timerUseCase: timerUseCase)
    viewModel.router = self

    let viewController = TimerSceneViewController(viewModel: viewModel)
    return viewController
  }

  init(parentRouter: Routing?, navigationController: UINavigationController?) {
    self.parentRouter = parentRouter
    self.navigationController = navigationController
  }
}

// MARK: StartMealTimerSceneRouterFactoriable

extension StartMealTimerSceneRouterFactory: StartMealTimerSceneRouterFactoriable {
  func pushSuccessScene() {
    let router = MealGokSuccessSceneRouterFactory(router: self, navigationController: navigationController)
    childRouters.append(router)
    router.start(build: router.build())
  }
}
