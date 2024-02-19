//
//  TimerLocalNotificationUseCase.swift
//  MealTimerFeature
//
//  Created by MaraMincho on 2/19/24.
//  Copyright © 2024 com.maramincho. All rights reserved.
//

import Foundation
import UserNotifications
import OSLog

// MARK: - TimerLocalNotificationUseCaseRepresentable

protocol TimerLocalNotificationUseCaseRepresentable {
  func addChallengeCompleteNotification(identifier notificationIdentifier: String)
  func removeChallengeCompleteNotification(identifier notificationIdentifier: String)
}

// MARK: - TimerLocalNotificationUseCase

final class TimerLocalNotificationUseCase: TimerLocalNotificationUseCaseRepresentable {
  private let timeInterval: Double

  init(minutes: Int, seconds: Int = 0) {
    timeInterval = Double(minutes * 60) + Double(seconds)
  }

  private var currentUserNotificationCenter = UNUserNotificationCenter.current()

  func addChallengeCompleteNotification(identifier notificationIdentifier: String) {
    let content = UNMutableNotificationContent()
    content.title = "Lunch time"
    content.body = "Food is cooked... let's eat!"

    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)

    let request = UNNotificationRequest(identifier: notificationIdentifier, content: content, trigger: trigger)
    UNUserNotificationCenter.current().add(request) { error in
      if let error {
        Logger().error("\(error.localizedDescription)")
      }
      
    }
  }

  func removeChallengeCompleteNotification(identifier notificationIdentifier: String) {
    currentUserNotificationCenter.removePendingNotificationRequests(withIdentifiers: [notificationIdentifier])
  }
}
