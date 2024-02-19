//
//  MealGokPushNotificationManager.swift
//  MealGok
//
//  Created by MaraMincho on 2/19/24.
//  Copyright © 2024 com.maramincho. All rights reserved.
//

import OSLog
import UIKit
import UserNotifications

// MARK: - MealGokPushNotificationManager

final class MealGokPushNotificationManager: UINavigationController {
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

extension MealGokPushNotificationManager: UNUserNotificationCenterDelegate {
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

  func userNotificationCenter(_: UNUserNotificationCenter, didReceive _: UNNotificationResponse) async {
    guard
      let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
      let rootViewController = windowScene.windows.first?.rootViewController
    else {
      return
    }
    let vc = UIViewController()
    vc.view.backgroundColor = .blue
    rootViewController.present(vc, animated: true)
    return
  }

  func userNotificationCenter(_: UNUserNotificationCenter, willPresent _: UNNotification) async -> UNNotificationPresentationOptions {
    return [.badge, .sound, .badge, .banner]
  }
}
