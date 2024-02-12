//
//  SharedPostNotification.swift
//  SharedNotificationName
//
//  Created by MaraMincho on 2/12/24.
//  Copyright © 2024 com.maramincho. All rights reserved.
//

import Foundation

public enum SharedPostNotification {
  
  /// "어플리케이션을 첫 화면으로 보내기 위한 NotificationName"을 
  /// NotificationCenter.default 로 방출합니다.
  public static func goHome() {
    NotificationCenter.default.post(name: .goHome, object: nil)
  }

  /// "어플리케이션을 초기 상태로 되돌리고 다시 로드하기 위한 NotificationName"을
  /// NotificationCenter.default로 메세지를 방출합니다.
  public static func goHomeAndReBuild() {
    NotificationCenter.default.post(name: .goHomeAndReBuild, object: nil)
  }
}
