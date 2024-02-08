//
//  MealGokHistoryFetchUseCase.swift
//  ProfileFeature
//
//  Created by MaraMincho on 2/8/24.
//  Copyright © 2024 com.maramincho. All rights reserved.
//

import Foundation

// MARK: - MealGokHistoryFetchUseCaseRepresentable

protocol MealGokHistoryFetchUseCaseRepresentable {}

// MARK: - MealGokHistoryFetchUseCase

final class MealGokHistoryFetchUseCase: MealGokHistoryFetchUseCaseRepresentable {
  let fetchRepository: MealGokHistoryFetchRepositoryRepresentable

  init(fetchRepository: MealGokHistoryFetchRepositoryRepresentable) {
    self.fetchRepository = fetchRepository
  }

  func fetchHistoryBy(startDate: Date) -> MealGokChallengeProperty {
    return fetchRepository.fetch(date: startDate)
  }
}
