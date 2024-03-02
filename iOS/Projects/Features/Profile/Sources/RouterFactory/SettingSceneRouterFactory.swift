//
//  SettingSceneRouterFactory.swift
//  ProfileFeature
//
//  Created by MaraMincho on 2/22/24.
//  Copyright © 2024 com.maramincho. All rights reserved.
//

import Combine
import ProfileHamburgerFeature
import RouterFactory
import UIKit

// MARK: - SettingViewModelRouterable

protocol SettingViewModelRouterable: RouterFactoriable {
  func goBack()
  func pushEditProfile()
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
    let viewModel = SettingViewModel(router: self, settingTableViewProperties: Constants.settingTableViewProperties)
    let viewController = SettingViewController(viewModel: viewModel)
    return viewController
  }
}

// MARK: SettingViewModelRouterable

extension SettingSceneRouterFactory: SettingViewModelRouterable {
  func pushEditProfile() {
    let editProfileRouterFactory = EditProfileRouterFactory(parentRouter: self, navigationController: navigationController)
    childRouters.append(editProfileRouterFactory)
    editProfileRouterFactory.start(build: editProfileRouterFactory.build())
  }

  func goBack() {
    navigationController?.popViewController(animated: true)
    popRouter()
  }

  private enum Constants {
    static let settingTableViewProperties: [SettingTableViewProperty] = [
      .init(titleText: "프로필 수정", imageSystemName: "person.fill"),
    ]
  }
}
