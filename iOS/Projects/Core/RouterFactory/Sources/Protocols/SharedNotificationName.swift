//
//  SharedNotificationName.swift
//  RouterFactory
//
//  Created by MaraMincho on 2/2/24.
//  Copyright © 2024 com.maramincho. All rights reserved.
//

import Foundation

public extension Notification.Name {
  /// 앱을 초기 상태로 되돌리고 다시 로드합니다.
  static let goHomeAndReBuild: Self = .init("GoHomeAndReBuild")

  /// 앱을 첫 화면으로 보냅니다.
  static let goHome: Self = .init("GoHome")
}

// MARK: - SharedRouterNotificationCenter

public enum SharedRouterNotificationCenter {
  public static func goHome() {
    NotificationCenter.default.post(name: .goHome, object: nil)
  }

  public static func goHomeAndReBuild() {
    NotificationCenter.default.post(name: .goHomeAndReBuild, object: nil)
  }
}
