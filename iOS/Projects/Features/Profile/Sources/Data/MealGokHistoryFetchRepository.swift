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

final class MealGokHistoryFetchRepository: PersistableRepository {
  let dateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-mm-dd"
    return dateFormatter
  }()
}

// MARK: MealGokHistoryFetchRepositoryRepresentable

extension MealGokHistoryFetchRepository: MealGokHistoryFetchRepositoryRepresentable {
  func fetch(date: Date) -> [MealGokChallengeProperty] {
    let dateString = dateFormatter.string(from: date)
    let objects = realm.objects(MealGokChallengePersistedObject.self).where { $0.challengeDateString.equals(dateString) }

    let challengeProperties: [MealGokChallengeProperty] = objects.map { .init(
      challengeDateString: $0.challengeDateString,
      endTime: $0.endTime,
      startTime: $0.startTime,
      imageDateURL: $0.imageDataURL,
      isSuccess: $0.isSuccess
    )
    }
    return challengeProperties
  }
}
