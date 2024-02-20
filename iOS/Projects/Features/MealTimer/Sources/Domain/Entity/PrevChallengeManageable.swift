//
//  PrevChallengeManagerable.swift
//  MealTimerFeature
//
//  Created by MaraMincho on 2/20/24.
//  Copyright © 2024 com.maramincho. All rights reserved.
//

import Foundation

// MARK: - PrevChallengeLoadManager

protocol PrevChallengeLoadManageable {
  func prevChallengeStartDate() -> Date?
  func prevChallengeTotalSeconds() -> Int
}

// MARK: - PrevChallengeWriteManager

protocol PrevChallengeWriteManageable {
  func setPrevChallengeStartDate(_ date: Date)
  func setPrevChallengeTotalSeconds(_ value: Int)
}

typealias PrevChallengeManageable = PrevChallengeLoadManageable & PrevChallengeWriteManageable
