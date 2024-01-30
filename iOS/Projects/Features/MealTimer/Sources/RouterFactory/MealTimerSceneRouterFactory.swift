//
//  MealTimerSceneRouterFactory.swift
//  MealTimerFeature
//
//  Created by MaraMincho on 1/30/24.
//  Copyright © 2024 com.maramincho. All rights reserved.
//

import RouterFactory
import UIKit

public final class MealTimerSceneRouterFactory: RouteFactoriable {
  public var parentRouter: Routing?

  public var navigationController: UINavigationController?

  public var childRouters: [Routing] = []

  public func start(build: UIViewController) {
    navigationController?.setViewControllers([build], animated: true)
  }

  public func build() -> UIViewController {
    let viewModel = MealTimerSceneViewModel()
    return MealTimerSceneViewController(viewModel: viewModel)
  }

  public init(_ parentRouter: Routing, navigationController: UINavigationController?) {
    self.parentRouter = parentRouter
    self.navigationController = navigationController
  }
}
