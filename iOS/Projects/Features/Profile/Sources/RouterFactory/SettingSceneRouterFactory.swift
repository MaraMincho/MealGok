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
import SafariServices
import UIKit

// MARK: - SettingViewModelRouterable

protocol SettingViewModelRouterable: RouterFactoriable {
  func goBack()
  func pushEditProfile()
  func pushSuggestion()
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

  func pushSuggestion() {
    guard let url = URL(string: Constants.urlString) else {
      return
    }
    let suggestionViewController = SFSafariViewController(url: url)
    navigationController?.present(suggestionViewController, animated: true)
  }

  func goBack() {
    navigationController?.popViewController(animated: true)
    popRouter()
  }

  private enum Constants {
    static let settingTableViewProperties = SettingTableViewPropertyItem.allCases.map(\.toProperty)
    static let urlString = "https://form.naver.com/response/rn-IUkIOWXeo0ZLgyNTZdQ"
  }
}

// MARK: - SettingTableViewPropertyItem

enum SettingTableViewPropertyItem: Int, Identifiable, CaseIterable {
  var id: Int { rawValue }
  case settingProfile = 0
  case suggestions

  var toProperty: SettingTableViewProperty {
    switch self {
    case .settingProfile:
      .init(id: rawValue, titleText: "프로필 수정", imageSystemName: "person.fill")
    case .suggestions:
      .init(id: rawValue, titleText: "건의사항", imageSystemName: "envelope.fill")
    }
  }
}
