//
//  SaveMealGokChalengeRepository.swift
//  MealTimerFeature
//
//  Created by MaraMincho on 2/7/24.
//  Copyright © 2024 com.maramincho. All rights reserved.
//

import Foundation
import RealmSwift

// MARK: - SaveMealGokChalengeRepository

final class SaveMealGokChalengeRepository: SaveMealGokChalengeRepositoryRepresentable {
  func save(mealGokChallengeDTO _: MealGokChallengeDTO) throws {
    // let persistableObject = MealGokChallengePersistedObject(dto: dto)
  }

  let realm: Realm
  init() throws {
    realm = try Realm()
  }
}
