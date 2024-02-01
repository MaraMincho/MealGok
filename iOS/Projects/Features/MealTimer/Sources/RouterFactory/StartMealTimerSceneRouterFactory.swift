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

protocol StartMealTimerSceneRouterFactoriable: RouterFactoriable {}

// MARK: - StartMealTimerSceneRouterFactory

final class StartMealTimerSceneRouterFactory: RouterFactoriable {
  weak var parentRouter: Routing?

  var navigationController: UINavigationController?

  var childRouters: [Routing] = []

  func start(build: UIViewController) {
    navigationController?.pushViewController(build, animated: false)
  }

  func build() -> UIViewController {
    let customStringFormatter = CustomTimeStringFormatter(totalMinutes: 20)
    let timerUseCase = TimerUseCase(customStringFormatter: customStringFormatter)

    let viewModel = TimerSceneViewModel(timerUseCase: timerUseCase)

    let viewController = TimerSceneViewController(viewModel: viewModel)
    return viewController
  }

  init(parentRouter: Routing? = nil, navigationController: UINavigationController?) {
    self.parentRouter = parentRouter
    self.navigationController = navigationController
  }
}
