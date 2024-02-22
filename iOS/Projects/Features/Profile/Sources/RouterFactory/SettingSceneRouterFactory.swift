//
//  SEtting.swift
//  ProfileFeature
//
//  Created by MaraMincho on 2/22/24.
//  Copyright © 2024 com.maramincho. All rights reserved.
//

import UIKit
import RouterFactory

protocol SettingViewModelRouterable: RouterFactoriable {
  
}

final class SettingSceneRouterFactory: RouterFactoriable {
  
  init(parentRouter: Routing?, navigationController: UINavigationController?) {
    self.parentRouter = parentRouter
    self.navigationController = navigationController
  }

  weak var parentRouter: Routing?
  
  weak var navigationController: UINavigationController?
  
  var childRouters: [Routing] = []
  
  func start(build: UIViewController) {
    navigationController?.pushViewController(build, animated: true)
  }
  
  func build() -> UIViewController {
    let viewModel = SettingViewModel(router: self)
    let viewController = SettingViewController(viewModel: viewModel)
    return viewController
  }
}

extension SettingSceneRouterFactory: SettingViewModelRouterable {
  
}
