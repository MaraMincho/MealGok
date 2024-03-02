//
//  EditProfileRouterFactory.swift
//  ProfileHamburgerFeature
//
//  Created by MaraMincho on 2/27/24.
//  Copyright © 2024 com.maramincho. All rights reserved.
//

import MealGokCacher
import RouterFactory
import SharedNotificationName
import UIKit

// MARK: - EditProfileRoutable

protocol EditProfileRoutable: Routing {
  func popViewController()
  func didEditAndSaveProfile()
}

// MARK: - EditProfileRouterFactory

public final class EditProfileRouterFactory: RouterFactoryBase {
  override public func build() -> UIViewController {
    let profileEditRepository = ProfileEditRepository()

    let profileEditCheckUseCase = ProfileEditCheckUseCase()
    let profileEditUseCase = ProfileEditUseCase(profileEditRepository: profileEditRepository)

    let viewModel = EditProfileViewModel(
      profileEditUseCase: profileEditUseCase,
      profileEditCheckUseCase: profileEditCheckUseCase,
      editProfileRoutable: self
    )
    let viewController = EditProfileViewController(viewModel: viewModel)

    return viewController
  }

  override public func start(build viewController: UIViewController) {
    navigationController?.pushViewController(viewController, animated: true)
  }
}

// MARK: EditProfileRoutable

extension EditProfileRouterFactory: EditProfileRoutable {
  func popViewController() {
    popRouter()
    navigationController?.popViewController(animated: true)
  }

  func didEditAndSaveProfile() {
    NotificationCenter.default.post(name: .goHomeAndReBuild, object: nil)
  }
}
