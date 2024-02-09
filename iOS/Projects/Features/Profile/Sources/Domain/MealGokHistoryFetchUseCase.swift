//
//  MealGokHistoryFetchUseCase.swift
//  ProfileFeature
//
//  Created by MaraMincho on 2/8/24.
//  Copyright © 2024 com.maramincho. All rights reserved.
//

import Foundation

// MARK: - MealGokHistoryFetchUseCaseRepresentable

protocol MealGokHistoryFetchUseCaseRepresentable {
  func fetchHistoryBy(startDateString str: String) -> [MealGokChallengeProperty]
  func fetchAllHistoryDateComponents() -> [DateComponents]
}

// MARK: - MealGokHistoryFetchUseCase

final class MealGokHistoryFetchUseCase: MealGokHistoryFetchUseCaseRepresentable {
  let fetchRepository: MealGokHistoryFetchRepositoryRepresentable

  init(fetchRepository: MealGokHistoryFetchRepositoryRepresentable) {
    self.fetchRepository = fetchRepository
  }

  func fetchHistoryBy(startDateString str: String) -> [MealGokChallengeProperty] {
    return fetchRepository.fetch(dateString: str)
  }

  func fetchAllHistoryDateComponents() -> [DateComponents] {
    let objects = fetchRepository.fetchAllHistory()
    let hashableDate: [String] = Array(Set(objects.map(\.challengeDateString)))
    let gregorian = Calendar(identifier: .gregorian)
    let dateComponents = hashableDate.map { str in
      let yearMonthDay = str.split(separator: "-")
      return DateComponents(
        calendar: gregorian,
        year: Int(yearMonthDay[0]),
        month: Int(yearMonthDay[1]),
        day: Int(yearMonthDay[2])
      )
    }

    return dateComponents
  }
}
