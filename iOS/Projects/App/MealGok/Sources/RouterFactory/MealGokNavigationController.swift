//
//  MealGokNavigationController.swift
//  MealGok
//
//  Created by MaraMincho on 2/19/24.
//  Copyright © 2024 com.maramincho. All rights reserved.
//

import OSLog
import UIKit
import UserNotifications

// MARK: - MealGokNavigationController

final class MealGokNavigationController: UINavigationController {
  init() {
    super.init(nibName: nil, bundle: nil)
    UNUserNotificationCenter.current().delegate = self
  }

  @available(*, unavailable)
  required init?(coder _: NSCoder) {
    fatalError("cant use this method")
  }
}

// MARK: UNUserNotificationCenterDelegate

extension MealGokNavigationController: UNUserNotificationCenterDelegate {
  /// Add Push Notification Auth
  func requestNotificationAuth() {
    let authOptions = UNAuthorizationOptions(arrayLiteral: .alert, .badge, .sound)

    UNUserNotificationCenter
      .current()
      .requestAuthorization(options: authOptions) { _, error in
        if let error {
          Logger().debug("\(#function) \(error.localizedDescription)")
        }
      }
  }

  /// Some Logic receive the message
  func userNotificationCenter(_: UNUserNotificationCenter, didReceive _: UNNotificationResponse) async {}

  func userNotificationCenter(_: UNUserNotificationCenter, willPresent _: UNNotification) async -> UNNotificationPresentationOptions {
    return [.badge, .sound, .badge, .banner]
  }
}
