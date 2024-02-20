//
//  PrevChallengeManageable.swift
//  MealTimerFeature
//
//  Created by MaraMincho on 2/20/24.
//  Copyright © 2024 com.maramincho. All rights reserved.
//

import Foundation

// MARK: - PrevChallengeLoadManageable

protocol PrevChallengeLoadManageable {
  func prevChallengeStartDate() -> Date?
  func prevChallengeTotalSeconds() -> Int?
}

// MARK: - PrevChallengeWriteManageable

protocol PrevChallengeWriteManageable {
  func setPrevChallengeStartDate(_ date: Date)
  func setPrevChallengeTotalSeconds(_ value: Int)
}

typealias PrevChallengeManageable = PrevChallengeLoadManageable & PrevChallengeWriteManageable
