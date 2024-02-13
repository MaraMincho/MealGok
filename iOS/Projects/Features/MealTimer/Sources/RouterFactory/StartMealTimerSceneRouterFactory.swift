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
  var startTime: Date

  private let targetTimeOfMinutes: Int

  func start(build: UIViewController) {
    navigationController?.pushViewController(build, animated: false)
    navigationController?.interactivePopGestureRecognizer?.isEnabled = false
  }

  func build() -> UIViewController {
    let repository = SaveMealGokChalengeRepository()
    let customStringFormatter = CustomTimeStringFormatter(minutes: targetTimeOfMinutes, seconds: 0)
    let timerUseCase = TimerUseCase(startTime: startTime, customStringFormatter: customStringFormatter, repository: repository)

    let viewModel = TimerSceneViewModel(timerUseCase: timerUseCase)
    viewModel.router = self

    let viewController = TimerSceneViewController(viewModel: viewModel)
    return viewController
  }

  init(startTime: Date, parentRouter: Routing?, navigationController: UINavigationController?, targetTimeOfMinutes: Int) {
    self.startTime = startTime
    self.parentRouter = parentRouter
    self.navigationController = navigationController
    self.targetTimeOfMinutes = targetTimeOfMinutes
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
