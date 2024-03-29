//
//  MealGokHistoryFetchRepository.swift
//  ProfileFeature
//
//  Created by MaraMincho on 2/8/24.
//  Copyright © 2024 com.maramincho. All rights reserved.
//

import Foundation
import ThirdParty

// MARK: - MealGokHistoryFetchRepository

final class MealGokHistoryFetchRepository: PersistableRepository {}

// MARK: MealGokHistoryFetchRepositoryRepresentable

extension MealGokHistoryFetchRepository: MealGokHistoryFetchRepositoryRepresentable {
  func fetchAllHistory() -> [MealGokChallengeProperty] {
    let objects = realm.objects(MealGokChallengePersistedObject.self)

    let challengeProperties: [MealGokChallengeProperty] = objects.map { .init(
      challengeDateString: $0.challengeDateString,
      endTime: $0.endTime,
      startTime: $0.startTime,
      imageDateURL: $0.imageDataURL,
      isSuccess: $0.isSuccess
    ) }
    return challengeProperties
  }

  func fetch(dateString: String) -> [MealGokChallengeProperty] {
    let objects = realm.objects(MealGokChallengePersistedObject.self).where { $0.challengeDateString.equals(dateString) }
    let challengeProperties: [MealGokChallengeProperty] = objects.map { .init(
      challengeDateString: $0.challengeDateString,
      endTime: $0.endTime,
      startTime: $0.startTime,
      imageDateURL: $0.imageDataURL,
      isSuccess: $0.isSuccess
    ) }

    return challengeProperties
  }
}
