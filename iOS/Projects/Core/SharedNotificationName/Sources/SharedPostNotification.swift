//
//  SharedPostNotification.swift
//  SharedNotificationName
//
//  Created by MaraMincho on 2/12/24.
//  Copyright © 2024 com.maramincho. All rights reserved.
//

import Foundation

public enum SharedPostNotification {
  public static func goHome() {
    NotificationCenter.default.post(name: .goHome, object: nil)
  }

  public static func goHomeAndReBuild() {
    NotificationCenter.default.post(name: .goHomeAndReBuild, object: nil)
  }
}
