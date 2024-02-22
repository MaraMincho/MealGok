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
  let showHistoryContent: AnyPublisher<MealGokChallengeProperty, Never>
  let didTapSettingButton: AnyPublisher<Void, Never>
  let updateProfile: AnyPublisher<Void, Never>
}

public typealias ProfileViewModelOutput = AnyPublisher<ProfileState, Never>

// MARK: - ProfileState

public enum ProfileState {
  case idle
  case updateContent
  case updateMealGokChallengeHistoryDate([Date])
  case updateTargetDayMealGokChallengeContent([MealGokChallengeProperty])
  case showHistoryContent(MealGokChallengeProperty)
  case updateProfile(name: String, imageUrl: URL?, biography: String)
}

// MARK: - ProfileViewModelRepresentable

protocol ProfileViewModelRepresentable {
  func transform(input: ProfileViewModelInput) -> ProfileViewModelOutput
}

// MARK: - ProfileViewModel

final class ProfileViewModel {
  // MARK: - Properties

  private var subscriptions: Set<AnyCancellable> = []
  private weak var router: ProfileSceneRouterable?

  private let mealGokHistoryFetchUseCase: MealGokHistoryFetchUseCase
  private let profileFetchUseCase: ProfileFetchUseCaseRepresentable

  init(
    mealGokHistoryFetchUseCase: MealGokHistoryFetchUseCase,
    profileFetchUseCase: ProfileFetchUseCaseRepresentable,
    profileSceneRouterable router: ProfileSceneRouterable
  ) {
    self.mealGokHistoryFetchUseCase = mealGokHistoryFetchUseCase
    self.profileFetchUseCase = profileFetchUseCase
    self.router = router
  }
}

// MARK: ProfileViewModelRepresentable

extension ProfileViewModel: ProfileViewModelRepresentable {
  public func transform(input: ProfileViewModelInput) -> ProfileViewModelOutput {
    subscriptions.removeAll()

    let updateName = input
      .updateProfile
      .map { [profileFetchUseCase] _ in
        let name = profileFetchUseCase.loadUserName()
        let profileImageURL = profileFetchUseCase.loadUserImageURL()
        let biography = profileFetchUseCase.loadUserBiography()
        return ProfileState.updateProfile(name: name, imageUrl: profileImageURL, biography: biography)
      }

    let updateHistoryDate = input.fetchMealGokHistory
      .compactMap { [weak self] _ in self?.mealGokHistoryFetchUseCase.fetchAllHistoryDateComponents() }
      .map { ProfileState.updateMealGokChallengeHistoryDate($0) }
      .eraseToAnyPublisher()

    let updateDate = input.didChangeDate
      .compactMap { [weak self] components -> [MealGokChallengeProperty]? in
        guard let self else { return nil }
        let contents = mealGokHistoryFetchUseCase.fetchHistoryBy(dateComponents: components)
        return contents
      }
      .map { ProfileState.updateTargetDayMealGokChallengeContent($0) }

    let showHistoryContent = input
      .showHistoryContent
      .map { ProfileState.showHistoryContent($0) }
      .eraseToAnyPublisher()

    input
      .didTapSettingButton
      .sink { [router] _ in
        router?.pushSettingScene()
      }
      .store(in: &subscriptions)

    let initialState: ProfileViewModelOutput = Just(.idle).eraseToAnyPublisher()

    return initialState.merge(with: updateHistoryDate, updateDate, showHistoryContent, updateName).eraseToAnyPublisher()
  }
}
