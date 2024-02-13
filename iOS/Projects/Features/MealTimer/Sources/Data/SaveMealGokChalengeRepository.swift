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
import ThirdParty

// MARK: - SaveMealGokChalengeRepository

final class SaveMealGokChalengeRepository: PersistableRepository, SaveMealGokChalengeRepositoryRepresentable {
  func save(mealGokChallengeDTO dto: MealGokChallengeDTO) throws {
    let persistableObject = dto.adaptPersistableObject()
    try realm.write {
      realm.add(persistableObject)
    }
  }

  override init() {
    super.init()
  }
}

// MARK: - MealGokChallengeDTO

public struct MealGokChallengeDTO {
  let startTime: Date
  let endTime: Date
  let isSuccess: Bool
  let imageDataURL: URL?
  var dateFormatter = DateFormatter()

  func adaptPersistableObject() -> MealGokChallengePersistedObject {
    dateFormatter.dateFormat = "yyyy-MM-dd"
    let dateString = dateFormatter.string(from: startTime)
    return .init(
      challengeDateString: dateString,
      startTime: startTime,
      endTime: endTime,
      imageDataURLString: imageDataURL?.lastPathComponent,
      isSuccess: isSuccess
    )
  }
}
