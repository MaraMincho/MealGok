//
//  TabBarRouteFactory.swift
//  RouteFactory
//
//  Created by MaraMincho on 1/30/24.
//  Copyright © 2024 com.maramincho. All rights reserved.
//

import UIKit


final class TabBarRouteFactory: RouteFactoriable {
  
  var parentRouter: Routing?
  
  var navigationController: UINavigationController?
  
  var childRouters: [Routing] = []
  
  
  func start(build: UIViewController) {
    navigationController?.setViewControllers([build], animated: false)
  }
  
  func build() -> UIViewController {
    let tabBarController = UITabBarController()
    tabBarController.setViewControllers(buildTabBarComponent(), animated: false)
    
    return tabBarController
  }
  
  private func buildTabBarComponent() -> [UIViewController] {
    let contents = TabBarScreenType.allCases.map { type in
      let nav = UINavigationController()
      nav.title = type.title
      nav.tabBarItem.image = type.image
      
      return nav
    }
    return contents
  }
  
}


enum TabBarScreenType: CaseIterable {
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
