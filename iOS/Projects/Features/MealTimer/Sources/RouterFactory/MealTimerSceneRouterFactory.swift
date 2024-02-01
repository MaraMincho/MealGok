//
//  MealTimerSceneRouterFactory.swift
//  MealTimerFeature
//
//  Created by MaraMincho on 1/30/24.
//  Copyright © 2024 com.maramincho. All rights reserved.
//

import RouterFactory
import UIKit

// MARK: - MealTimerSceneRouterFactoriable

protocol MealTimerSceneRouterFactoriable: RouterFactoriable {
  func startMealTimerScene()
}

// MARK: - MealTimerSceneRouterFactory

public final class MealTimerSceneRouterFactory: RouterFactoriable {
  public var parentRouter: Routing?

  public var navigationController: UINavigationController?

  public var childRouters: [Routing] = []

  public func start(build: UIViewController) {
    navigationController?.setViewControllers([build], animated: true)
  }

  public func build() -> UIViewController {
    let viewModel = MealTimerSceneViewModel()
    viewModel.router = self
    return MealTimerSceneViewController(viewModel: viewModel)
  }

  public init(_ parentRouter: Routing, navigationController: UINavigationController?) {
    self.parentRouter = parentRouter
    self.navigationController = navigationController
  }
}

// MARK: MealTimerSceneRouterFactoriable

extension MealTimerSceneRouterFactory: MealTimerSceneRouterFactoriable {
  func startMealTimerScene() {
    let router = MealGokSuccessSceneRouterFactory(router: self, navigationController: navigationController?.navigationController)
    childRouters.append(router)
    router.start(build: router.build())
//    let router = StartMealTimerSceneRouterFactory(navigationController: navigationController?.navigationController)
//    childRouters.append(router)
//    router.start(build: router.build())
  }
}
