//
//  RouteFactory.swift
//  RouteFactory
//
//  Created by MaraMincho on 1/30/24.
//  Copyright © 2024 com.maramincho. All rights reserved.
//

import Combine
import UIKit

// MARK: - RouterFactoriable

public protocol RouterFactoriable: Building & Routing {
  var popSubscription: Cancellable? { get set }
  /// 만약 topViewController가 build해서 나온 UIViewController일 때 child Rotuer들을 해제 합니다.
  func releaseChildCoordinatorIfTopView(buildViewController: UIViewController)
}

public extension RouterFactoriable {
  func releaseChildCoordinatorIfTopView(buildViewController viewController: UIViewController) {
    popSubscription = navigationController?.publisher(for: \.topViewController)
      .compactMap { topViewController in
        return topViewController === viewController ? () : nil
      }
      .sink { [weak self] _ in
        self?.childRouters = []
      }
  }
}

// MARK: - RouterFactory

public class RouterFactory: RouterFactoriable {
  public var popSubscription: Cancellable?
  public var parentRouter: Routing?
  public var navigationController: UINavigationController?
  public var childRouters: [Routing] = []

  public func build() -> UIViewController {
    return UIViewController()
  }

  public func start(build viewController: UIViewController) {
    releaseChildCoordinatorIfTopView(buildViewController: viewController)
    navigationController?.pushViewController(viewController, animated: true)
  }

  init(parentRouter: Routing?, navigationController: UINavigationController?) {
    self.parentRouter = parentRouter
    self.navigationController = navigationController
  }
}
