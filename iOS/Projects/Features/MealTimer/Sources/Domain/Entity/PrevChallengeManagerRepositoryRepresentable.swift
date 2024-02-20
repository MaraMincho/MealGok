//
//  PrevChallengeManagerRepositoryRepresentable.swift
//  MealTimerFeature
//
//  Created by MaraMincho on 2/20/24.
//  Copyright © 2024 com.maramincho. All rights reserved.
//

import Foundation

protocol PrevChallengeUserDefaultsManager {
  func prevChallengeStartDate() -> Date?
  func prevChallengeTotalSeconds() -> Int
  func setPrevChallengeStartDate(_ date: Date)
  func setPrevChallengeTotalSeconds(_ value: Int)
}
