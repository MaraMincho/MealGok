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
  func fetchHistoryBy(dateComponents: DateComponents) -> [MealGokChallengeProperty]
  func fetchAllHistoryDateComponents() -> [Date]
}

// MARK: - MealGokHistoryFetchUseCase

final class MealGokHistoryFetchUseCase: MealGokHistoryFetchUseCaseRepresentable {
  let fetchRepository: MealGokHistoryFetchRepositoryRepresentable
  let numberFormatter: NumberFormatter = {
    let numberFormatter = NumberFormatter()
    numberFormatter.minimumIntegerDigits = 2
    return numberFormatter
  }()

  let dateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"

    return dateFormatter
  }()

  func fetchHistoryBy(dateComponents: DateComponents) -> [MealGokChallengeProperty] {
    guard
      let year = dateComponents.year,
      let month = dateComponents.month,
      let day = dateComponents.day
    else {
      return []
    }
    let formattedMonth = numberFormatter.string(for: month) ?? ""
    let formattedDay = numberFormatter.string(for: day) ?? ""
    return fetchRepository.fetch(dateString: "\(year)-\(formattedMonth)-\(formattedDay)")
  }

  func fetchAllHistoryDateComponents() -> [Date] {
    let objects = fetchRepository.fetchAllHistory()
    let hashableDateString: [String] = Array(Set(objects.map(\.challengeDateString)))
    let hashableDate = hashableDateString.compactMap { dateFormatter.date(from: $0) }
    return hashableDate
  }

  init(fetchRepository: MealGokHistoryFetchRepositoryRepresentable) {
    self.fetchRepository = fetchRepository
  }
}
