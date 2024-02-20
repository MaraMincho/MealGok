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
  func startMealTimerScene(targetMinute: Int, startTime: Date)
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
    let repository = TargetTimeRepository()
    let targetTimeUseCase = TargetTimeUseCase(repository: repository)
    let savePhotoUseCase = SavePhotoUseCase()
    
    let prevChallengeLoadRepository = PrevChallengeManagerRepository()
    let prevChallengeLoadUseCase = PrevChallengeLoadUseCase(loader: prevChallengeLoadRepository)

    let viewModel = MealGokHomeViewModel(
      targetTimeUseCase: targetTimeUseCase,
      savePhotoUseCase: savePhotoUseCase,
      prevChallengeLoadUseCase: prevChallengeLoadUseCase
    )
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
  func startMealTimerScene(targetMinute: Int, startTime: Date) {
    let router = StartMealTimerSceneRouterFactory(
      startTime: startTime,
      parentRouter: self,
      navigationController: navigationController,
      targetTimeOfMinutes: targetMinute
    )
    childRouters.append(router)
    router.start(build: router.build())
  }
}
