//
//  SaveMealGokChalengeRepository.swift
//  MealTimerFeature
//
//  Created by MaraMincho on 2/7/24.
//  Copyright © 2024 com.maramincho. All rights reserved.
//

import Foundation
import OSLog
import RealmSwift

// MARK: - SaveMealGokChalengeRepository

final class SaveMealGokChalengeRepository: SaveMealGokChalengeRepositoryRepresentable {
  func save(mealGokChallengeDTO dto: MealGokChallengeDTO) throws {
    let persistableObject = MealGokChallengePersistedObject(dto: dto)

    try realm.write {
      realm.add(persistableObject)
      realm.add(fakeData())
    }
  }

  func fakeData() -> MealGokChallengePersistedObject {
    return MealGokChallengePersistedObject(dto: .init(startTime: .now - 600, endTime: .now + 600, isSuccess: true, imageDataURL: nil))
  }

  var realm: Realm
  init(realm: Realm) {
    self.realm = realm
  }
}

// MARK: - MealGokChallengePersistedObject

class MealGokChallengePersistedObject: Object {
  @Persisted(primaryKey: true) var _id: ObjectId
  @Persisted var endTime: Date?
  @Persisted var startTime: Date?
  @Persisted var imageDataURL: String?
  @Persisted var isSuccess: Bool?
  convenience init(dto: MealGokChallengeDTO) {
    self.init()
    endTime = dto.endTime
    startTime = dto.startTime
    imageDataURL = dto.imageDataURL?.absoluteString
    isSuccess = dto.isSuccess
  }
}
