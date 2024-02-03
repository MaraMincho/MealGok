//
//  ProfileSceneRouterFactory.swift
//  ProfileFeature
//
//  Created by MaraMincho on 2/3/24.
//  Copyright © 2024 com.maramincho. All rights reserved.
//

import UIKit
import RouterFactory

final class ProfileSceneRouterFactory: RouterFactoriable {
  weak var parentRouter: Routing?
  
  weak var navigationController: UINavigationController?
  
  var childRouters: [Routing] = []
  
  func start(build: UIViewController) {
    navigationController?.pushViewController(build, animated: true)
  }
  func build() -> UIViewController {
    let viewModel = ProfileViewModel()
    return ProfileViewController(viewModel: viewModel)
  }
  
  init(parentRouter: Routing?, navigationController: UINavigationController? ) {
    self.parentRouter = parentRouter
    self.navigationController = navigationController
  }
  
}
