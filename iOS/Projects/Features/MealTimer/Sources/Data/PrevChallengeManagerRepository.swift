//
//  PrevChallengeManagerRepository.swift
//  MealTimerFeature
//
//  Created by MaraMincho on 2/20/24.
//  Copyright © 2024 com.maramincho. All rights reserved.
//

import CommonExtensions
import Foundation

struct PrevChallengeManagerRepository: PrevChallengeManageable {
  private let startDateKey: String
  private let totalSecondsKey: String
  private let userDefaults = UserDefaults.standard

  init(
    startDateKey: String = Constants.startDateKey,
    totalSecondsKey: String = Constants.totalSecondsKey
  ) {
    self.startDateKey = startDateKey
    self.totalSecondsKey = totalSecondsKey
  }

  func prevChallengeStartDate() -> Date? {
    return userDefaults.date(forKey: startDateKey)
  }

  func prevChallengeTotalSeconds() -> Int? {
    let totalSeconds = userDefaults.integer(forKey: totalSecondsKey)
    return totalSeconds == 0 ? nil : totalSeconds
  }

  func setPrevChallengeStartDate(_ date: Date) {
    userDefaults.set(date: date, forKey: startDateKey)
  }

  func setPrevChallengeTotalSeconds(_ value: Int) {
    userDefaults.set(value, forKey: totalSecondsKey)
  }

  private enum Constants {
    static let startDateKey: String = "ChallengeStartDate"
    static let totalSecondsKey: String = "TargetTime"
  }
}
