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
  private let notificationContent: NotificationContent

  init(minutes: Int, seconds: Int = 0, notificationContent: NotificationContent = .init()) {
    timeInterval = Double(minutes * 60) + Double(seconds)
    self.notificationContent = notificationContent
  }

  private var currentUserNotificationCenter = UNUserNotificationCenter.current()

  func addChallengeCompleteNotification(identifier notificationIdentifier: String) {
    let content = UNMutableNotificationContent()
    content.title = notificationContent.notificationContentTitle
    content.body = notificationContent.notificationContentBody

    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)

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

struct NotificationContent {
  let notificationContentTitle: String
  let notificationContentBody: String
  
  init(
    notificationContentTitle: String = "목표한 시간동안 식사를 하셨습니다!",
    notificationContentBody: String = "식사를 기록하고, 공유하는 것은 어떨까요?"
  ) {
    self.notificationContentTitle = notificationContentTitle
    self.notificationContentBody = notificationContentBody
  }
}
