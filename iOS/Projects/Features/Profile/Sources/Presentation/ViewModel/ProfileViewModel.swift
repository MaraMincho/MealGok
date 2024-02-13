//
//  ProfileViewModel.swift
//  ProfileFeature
//
//  Created by MaraMincho on 2/3/24.
//  Copyright © 2024 com.maramincho. All rights reserved.
//

import Combine
import Foundation

// MARK: - ProfileViewModelInput

public struct ProfileViewModelInput {
  let didChangeDate: AnyPublisher<DateComponents, Never>
  let fetchMealGokHistory: AnyPublisher<Void, Never>
}

public typealias ProfileViewModelOutput = AnyPublisher<ProfileState, Never>

// MARK: - ProfileState

public enum ProfileState {
  case idle
  case updateContent
  case updateMealGokChallengeHistoryDate([Date])
  case updateTargetDayMealGokChallengeContent([MealGokChallengeProperty])
}

// MARK: - ProfileViewModelRepresentable

protocol ProfileViewModelRepresentable {
  func transform(input: ProfileViewModelInput) -> ProfileViewModelOutput
}

// MARK: - ProfileViewModel

final class ProfileViewModel {
  // MARK: - Properties

  private var subscriptions: Set<AnyCancellable> = []

  private let mealGokHistoryFetchUseCase: MealGokHistoryFetchUseCase

  init(mealGokHistoryFetchUseCase: MealGokHistoryFetchUseCase) {
    self.mealGokHistoryFetchUseCase = mealGokHistoryFetchUseCase
  }
}

// MARK: ProfileViewModelRepresentable

extension ProfileViewModel: ProfileViewModelRepresentable {
  public func transform(input: ProfileViewModelInput) -> ProfileViewModelOutput {
    subscriptions.removeAll()

    let updateHistoryDate = input.fetchMealGokHistory
      .compactMap { [weak self] _ in self?.mealGokHistoryFetchUseCase.fetchAllHistoryDateComponents() }
      .map { ProfileState.updateMealGokChallengeHistoryDate($0) }
      .eraseToAnyPublisher()

    let updateDate = input.didChangeDate
      .compactMap { [weak self] components -> [MealGokChallengeProperty]? in
        guard let self else { return nil }
        let contents = mealGokHistoryFetchUseCase.fetchHistoryBy(dateComponents: components)
        print(contents)
        return contents
      }
      .map { ProfileState.updateTargetDayMealGokChallengeContent($0) }

    let initialState: ProfileViewModelOutput = Just(.idle).eraseToAnyPublisher()

    return initialState.merge(with: updateHistoryDate, updateDate).eraseToAnyPublisher()
  }
}
