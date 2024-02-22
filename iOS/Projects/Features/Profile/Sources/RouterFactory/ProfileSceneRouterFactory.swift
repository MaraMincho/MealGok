//
//  ProfileSceneRouterFactory.swift
//  ProfileFeature
//
//  Created by MaraMincho on 2/3/24.
//  Copyright © 2024 com.maramincho. All rights reserved.
//

import Combine
import RouterFactory
import UIKit

// MARK: - ProfileSceneRouterable

protocol ProfileSceneRouterable: AnyObject {
  func pushSettingScene()
}

// MARK: - ProfileSceneRouterFactory

public final class ProfileSceneRouterFactory: RouterFactoriable {
  public weak var parentRouter: Routing?
  public weak var navigationController: UINavigationController?
  public var childRouters: [Routing] = []
  public var popSubscription: Cancellable?

  public func start(build: UIViewController) {
    navigationController?.pushViewController(build, animated: true)
  }

  public func build() -> UIViewController {
    let mealGokHistoryFetchRepository = MealGokHistoryFetchRepository()
    let mealGokHistoryFetchUseCase = MealGokHistoryFetchUseCase(fetchRepository: mealGokHistoryFetchRepository)

    let profileFetchRepository = ProfileFetchRepository()
    let profileFetchUseCase = ProfileFetchUseCase(profileFetchRepository: profileFetchRepository)

    let viewModel = ProfileViewModel(
      mealGokHistoryFetchUseCase: mealGokHistoryFetchUseCase,
      profileFetchUseCase: profileFetchUseCase,
      profileSceneRouterable: self
    )
    let initDate = DateComponents(calendar: Calendar(identifier: .gregorian), year: 2023, month: 1, day: 1).date!
    let property: ProfileViewControllerProperty = .init(startDate: initDate, endDate: Date.now)

    let viewController = ProfileViewController(viewModel: viewModel, property: property)

    releaseChildCoordinatorIfTopView(buildViewController: viewController)

    return viewController
  }

  public init(parentRouter: Routing?, navigationController: UINavigationController?) {
    self.parentRouter = parentRouter
    self.navigationController = navigationController
  }
}

// MARK: ProfileSceneRouterable

extension ProfileSceneRouterFactory: ProfileSceneRouterable {
  func pushSettingScene() {
    let settingRouterFactory = SettingSceneRouterFactory(parentRouter: self, navigationController: navigationController)
    childRouters.append(settingRouterFactory)
    settingRouterFactory.start(build: settingRouterFactory.build())
  }
}
