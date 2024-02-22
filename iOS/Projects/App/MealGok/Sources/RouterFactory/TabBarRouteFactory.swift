//
//  TabBarRouteFactory.swift
//  RouteFactory
//
//  Created by MaraMincho on 1/30/24.
//  Copyright © 2024 com.maramincho. All rights reserved.
//

import Combine
import DesignSystem
import MealGokCacher
import MealTimerFeature
import OSLog
import ProfileFeature
import RouterFactory
import UIKit

// MARK: - TabBarRouteFactory

public final class TabBarRouteFactory: RouterFactoriable {
  public init(parentRouter: Routing, navigationController: UINavigationController) {
    self.parentRouter = parentRouter
    self.navigationController = navigationController
  }

  public weak var parentRouter: Routing?

  public var navigationController: UINavigationController?

  public var childRouters: [Routing] = []
  public var popSubscription: Cancellable?

  public func start(build: UIViewController) {
    navigationController?.setViewControllers([build], animated: false)
    navigationController?.interactivePopGestureRecognizer?.isEnabled = false

    // mealgokcacher에 default사진들 메모리에 저장
    setDefaultSetting()
    MealGokCacher.storeMemory(with: Constants.url)
  }

  public func build() -> UIViewController {
    let tabBarController = UITabBarController()
    tabBarController.setViewControllers(buildTabBarComponent(), animated: false)
    tabBarController.tabBar.tintColor = DesignSystemColor.main01

    return tabBarController
  }

  // MARK: TabBarRouterFactory가 하는 일은 아니지만 splash 생기기 이전
  // TODO: spalsh화면으로 역할 이전
  private func setDefaultSetting() {
    let userDefaults = UserDefaults.standard
    if userDefaults.bool(forKey: Constants.mealGokMember) == false {
      // 기본 이미지 생성
      let configure: UIImage.SymbolConfiguration = .init(font: .systemFont(ofSize: 15))
      let image = UIImage(systemName: "person.fill", withConfiguration: configure)
      image?.withTintColor(DesignSystemColor.main01)
      let data = image?.pngData()
      MealGokCacher.save(fileName: Constants.profileImage, data: data)

      // 기본 이름 설정
      userDefaults.set("밀꼭꼭이", forKey: "MealGokName")
      userDefaults.set("안녕하세요 오늘도 좋은 하루 보내세요", forKey: "MealGokBiography")

      userDefaults.set(true, forKey: Constants.mealGokMember)
    }
    
  }

  private func buildTabBarComponent() -> [UIViewController] {
    let contents = TabBarScreenType.allCases.compactMap { type -> UIViewController? in
      return makeRouter(type: type)
    }
    return contents
  }

  private func makeRouter(type: TabBarScreenType) -> UIViewController {
    switch type {
    case .timer:
      let mealTimerRouterFactory = MealGokHomeRouterFactory(self, navigationController: navigationController)
      childRouters.append(mealTimerRouterFactory)
      let vc = mealTimerRouterFactory.build()
      vc.title = type.title
      vc.tabBarItem.image = type.image
      return vc
    case .profile:
      let profileRouterFactory = ProfileSceneRouterFactory(parentRouter: self, navigationController: navigationController)
      childRouters.append(profileRouterFactory)
      let vc = profileRouterFactory.build()
      vc.title = type.title
      vc.tabBarItem.image = type.image
      return vc
    }
  }

  private enum Constants {
    static let mealGokMember: String = "MealGokMember"
    static let profileImage: String = "MealGokProfileImage"
    static let url: [URL] = [
      UserDefaults.standard.url(forKey: profileImage),
    ]
    .compactMap { $0 }
  }

  // MARK: - TabBarScreenType

  private enum TabBarScreenType: CaseIterable {
    case timer
    case profile

    var image: UIImage? {
      switch self {
      case .timer:
        return UIImage(systemName: "fork.knife.circle")
      case .profile:
        return UIImage(systemName: "person.crop.circle")
      }
    }

    var title: String {
      switch self {
      case .timer:
        return "타이머"
      case .profile:
        return "프로필"
      }
    }
  }
}
