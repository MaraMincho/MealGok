//
//  MealGokHomeRouterFactory.swift
//  MealTimerFeature
//
//  Created by MaraMincho on 1/30/24.
//  Copyright © 2024 com.maramincho. All rights reserved.
//

import RouterFactory
import UIKit

// MARK: - MealGokHomeFactoriable

protocol MealGokHomeFactoriable: RouterFactoriable {
  func startMealTimerScene()
}

// MARK: - MealGokHomeRouterFactory

public final class MealGokHomeRouterFactory: RouterFactoriable {
  public weak var parentRouter: Routing?

  public weak var navigationController: UINavigationController?

  public var childRouters: [Routing] = []

  public func start(build: UIViewController) {
    navigationController?.pushViewController(build, animated: true)
  }

  public func build() -> UIViewController {
    let viewModel = MealGokHomeViewModel()
    viewModel.router = self
    return MealGokHomeViewController(viewModel: viewModel)
  }

  public init(_ parentRouter: Routing, navigationController: UINavigationController?) {
    self.parentRouter = parentRouter
    self.navigationController = navigationController
  }
}

// MARK: MealGokHomeFactoriable

extension MealGokHomeRouterFactory: MealGokHomeFactoriable {
  func startMealTimerScene() {
    let router = StartMealTimerSceneRouterFactory(
      parentRouter: self,
      navigationController: navigationController
    )
    childRouters.append(router)
    router.start(build: router.build())
  }
}
