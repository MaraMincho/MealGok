//
//  ProfileSceneRouterFactory.swift
//  ProfileFeature
//
//  Created by MaraMincho on 2/3/24.
//  Copyright © 2024 com.maramincho. All rights reserved.
//

import RouterFactory
import UIKit

public final class ProfileSceneRouterFactory: RouterFactoriable {
  public weak var parentRouter: Routing?

  public weak var navigationController: UINavigationController?

  public var childRouters: [Routing] = []

  public func start(build: UIViewController) {
    navigationController?.pushViewController(build, animated: true)
  }

  public func build() -> UIViewController {
    let mealGokHistoryFetchRepository = MealGokHistoryFetchRepository()
    let mealGokHistoryFetchUseCase = MealGokHistoryFetchUseCase(fetchRepository: mealGokHistoryFetchRepository)
    let viewModel = ProfileViewModel(mealGokHistoryFetchUseCase: mealGokHistoryFetchUseCase)
    let initDate = DateComponents(calendar: Calendar(identifier: .gregorian), year: 2023, month: 1, day: 1).date!
    let property: ProfileViewControllerProperty = .init(startDate: initDate, endDate: Date.now)
    return ProfileViewController(viewModel: viewModel, property: property)
  }

  public init(parentRouter: Routing?, navigationController: UINavigationController?) {
    self.parentRouter = parentRouter
    self.navigationController = navigationController
  }
}
