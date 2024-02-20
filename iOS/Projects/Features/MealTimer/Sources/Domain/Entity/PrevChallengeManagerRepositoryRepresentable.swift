//
//  PrevChallengeManagerRepositoryRepresentable.swift
//  MealTimerFeature
//
//  Created by MaraMincho on 2/20/24.
//  Copyright © 2024 com.maramincho. All rights reserved.
//

import Foundation

protocol PrevChallengeLoadManager {
  func prevChallengeStartDate() -> Date?
  func prevChallengeTotalSeconds() -> Int
}

protocol PrevChallengeWriteManager {
  func setPrevChallengeStartDate(_ date: Date)
  func setPrevChallengeTotalSeconds(_ value: Int)
}

typealias PrevChallengeManager = PrevChallengeWriteManager & PrevChallengeLoadManager
