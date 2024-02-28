//
//  EditProfileRouterFactory.swift
//  ProfileHamburgerFeature
//
//  Created by MaraMincho on 2/27/24.
//  Copyright © 2024 com.maramincho. All rights reserved.
//

import UIKit
import RouterFactory

public final class EditProfileRouterFactory: RouterFactoryBase {
  override public func build() -> UIViewController {
    let viewModel = EditProfileViewModel()
    let viewController = EditProfileViewController(viewModel: viewModel)
    return viewController
  }
}
