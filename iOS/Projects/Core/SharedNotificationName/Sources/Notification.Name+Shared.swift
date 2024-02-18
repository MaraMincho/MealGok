//
//  Notification.Name+Shared.swift
//  SharedNotificationName
//
//  Created by MaraMincho on 2/12/24.
//  Copyright © 2024 com.maramincho. All rights reserved.
//

import Foundation

public extension Notification.Name {
  /// 어플리케이션을 초기 상태로 되돌리고 다시 로드하기 위한 NotificationName입니다.
  static let goHomeAndReBuild: Self = .init("GoHomeAndReBuild")

  /// 어플리케이션을 첫 화면으로 보내기 위한 NotificationName입니다.
  static let goHome: Self = .init("GoHome")

  /// 어플리케이션을 only portrait Mode로 지원하기 위한 NotificationName입니다.
  static let portraitScreenMode: Self = .init("PortraitScreenMode")

  /// 어플리케이션을 모든 화면 전환에 대해 지원하기 위한 NotificationName입니다.
  static let allScreenMode: Self = .init("AllScreenMode")
}
