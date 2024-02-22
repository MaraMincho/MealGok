//
//  SettingSceneRouterFactory.swift
//  ProfileFeature
//
//  Created by MaraMincho on 2/22/24.
//  Copyright © 2024 com.maramincho. All rights reserved.
//

import Combine
import RouterFactory
import UIKit

// MARK: - SettingViewModelRouterable

protocol SettingViewModelRouterable: RouterFactoriable {
  func goBack()
}

// MARK: - SettingSceneRouterFactory

final class SettingSceneRouterFactory: RouterFactoriable {
  init(parentRouter: Routing?, navigationController: UINavigationController?) {
    self.parentRouter = parentRouter
    self.navigationController = navigationController
  }

  weak var parentRouter: Routing?
  weak var navigationController: UINavigationController?
  var childRouters: [Routing] = []
  var popSubscription: Cancellable?

  func start(build: UIViewController) {
    navigationController?.pushViewController(build, animated: true)
  }

  func build() -> UIViewController {
    let viewModel = SettingViewModel(router: self)
    let viewController = SettingViewController(viewModel: viewModel)
    return viewController
  }
}

// MARK: SettingViewModelRouterable

extension SettingSceneRouterFactory: SettingViewModelRouterable {
  func goBack() {
    navigationController?.popViewController(animated: true)
    popRouter()
  }
}
