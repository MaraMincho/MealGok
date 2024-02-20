//
//  PrevChallengeManagerRepository.swift
//  MealTimerFeature
//
//  Created by MaraMincho on 2/20/24.
//  Copyright © 2024 com.maramincho. All rights reserved.
//

import Foundation
import CommonExtensions

struct PrevChallengeManagerRepository: PrevChallengeUserDefaultsManager {
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
  
  func prevChallengeTotalSeconds() -> Int {
    return userDefaults.integer(forKey: totalSecondsKey)
  }
  
  func setPrevChallengeStartDate(_ date: Date) {
    userDefaults.set(date: date, forKey: startDateKey)
  }
  
  func setPrevChallengeTotalSeconds(_ value: Int){
    userDefaults.set(value, forKey: totalSecondsKey)
  }
  
  private enum Constants {
    static let startDateKey: String = "ChallengeStartDate"
    static let totalSecondsKey: String = "TargetTime"
  }
}
