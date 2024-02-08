//
//  SaveMealGokChalengeRepositoryRepresentable.swift
//  MealTimerFeature
//
//  Created by MaraMincho on 2/7/24.
//  Copyright © 2024 com.maramincho. All rights reserved.
//

import Foundation

// MARK: - SaveMealGokChalengeRepositoryRepresentable

protocol SaveMealGokChalengeRepositoryRepresentable {
  func save(mealGokChallengeDTO: MealGokChallengeDTO) throws
}

// MARK: - MealGokChallengeDTO

struct MealGokChallengeDTO {
  let startTime: Date?
  let endTime: Date?
  let isSuccess: Bool?
  let imageDataURL: URL?
}
