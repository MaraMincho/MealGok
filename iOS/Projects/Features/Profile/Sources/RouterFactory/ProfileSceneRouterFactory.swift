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
    let viewModel = ProfileViewModel()
    return ProfileViewController(viewModel: viewModel)
  }

  public init(parentRouter: Routing?, navigationController: UINavigationController?) {
    self.parentRouter = parentRouter
    self.navigationController = navigationController
  }
}
