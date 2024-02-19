//
//  TimerLocalNotificationUseCase.swift
//  MealTimerFeature
//
//  Created by MaraMincho on 2/19/24.
//  Copyright © 2024 com.maramincho. All rights reserved.
//

import Foundation
import UserNotifications

// MARK: - TimerLocalNotificationUseCaseRepresentable

protocol TimerLocalNotificationUseCaseRepresentable {
  func addChallengeCompleteNotification(identifier notificationIdentifier: String, timeInterval: Double)
  func removeChallengeCompleteNotification(identifier notificationIdentifier: String)
}

// MARK: - TimerLocalNotificationUseCase

final class TimerLocalNotificationUseCase: TimerLocalNotificationUseCaseRepresentable {
  private var currentUserNotificationCenter = UNUserNotificationCenter.current()
  func addChallengeCompleteNotification(identifier notificationIdentifier: String, timeInterval: Double) {
    let content = UNMutableNotificationContent()
    content.title = "Lunch time"
    content.body = "Food is cooked... let's eat!"

    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)

    let request = UNNotificationRequest(identifier: notificationIdentifier, content: content, trigger: trigger)

    currentUserNotificationCenter.add(request) { _ in
    }
  }

  func removeChallengeCompleteNotification(identifier notificationIdentifier: String) {
    currentUserNotificationCenter.removePendingNotificationRequests(withIdentifiers: [notificationIdentifier])
  }
}
