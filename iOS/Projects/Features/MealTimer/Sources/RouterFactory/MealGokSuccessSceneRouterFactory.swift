//
//  MealGokSuccessSceneRouterFactory.swift
//  MealTimerFeature
//
//  Created by MaraMincho on 2/1/24.
//  Copyright © 2024 com.maramincho. All rights reserved.
//

import RouterFactory
import SharedNotificationName
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

    let date = Date.now
    let formatter = DateFormatter()
    formatter.dateFormat = "YYYY. MM. DD"
    let dateString = formatter.string(from: date)
    let viewController = MealGokSuccessSceneViewController(
      viewModel: viewModel,
      mealGokContentProperty: .init(date: dateString, pictureURL: nil, title: Constants.title, description: Constants.description)
    )
    return viewController
  }

  private enum Constants {
    static let title = "즐거운 식사 되셨나요?"
    static let description = "허겁지겁 먹다 보면, 중요한 것을 놓치는 경우가 더러 있습니다.  소중한 시간을 음미하며 오늘 하루도 화이팅 하세요 !"
  }
}

// MARK: MealGokSuccessSceneRouter

extension MealGokSuccessSceneRouterFactory: MealGokSuccessSceneRouter {
  func goHome() {
    SharedPostNotification.goHomeAndReBuild()
  }
}
