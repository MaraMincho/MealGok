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
  func fetch(date _: Date) -> MealGokChallengeProperty {
    let objects = realm.objects(MealGokChallengePersistedObject.self)
    return .init()
  }
}
