//
//  EditProfileViewModel.swift
//  ProfileHamburgerFeature
//
//  Created by MaraMincho on 2/27/24.
//  Copyright © 2024 com.maramincho. All rights reserved.
//

import Combine
import Foundation

// MARK: - EditProfileViewModelInput

public struct EditProfileViewModelInput {
  let loadProfileInformation: AnyPublisher<Void, Never>
  let editNickName: AnyPublisher<String, Never>
  let editImage: AnyPublisher<Data, Never>
  let editBiography: AnyPublisher<String, Never>
  let didTapSaveButton: AnyPublisher<Void, Never>
}

public typealias EditProfileViewModelOutput = AnyPublisher<EditProfileState, Never>

// MARK: - EditProfileState

public enum EditProfileState {
  case idle
  case nickName(String)
  case profileImage(URL)
  case biography(String)
  case invalidNickName(String)
  case validNickname
  case emptyNickName
}

// MARK: - EditProfileViewModelRepresentable

protocol EditProfileViewModelRepresentable {
  func transform(input: EditProfileViewModelInput) -> EditProfileViewModelOutput
}

// MARK: - EditProfileViewModel

final class EditProfileViewModel {
  // MARK: - Properties

  private var subscriptions: Set<AnyCancellable> = []
  private let profileEditUseCase: ProfileEditUseCaseRepresentable
  private let profileEditCheckUseCase: ProfileEditCheckUseCaseRepresentable

  init(
    profileEditUseCase: ProfileEditUseCaseRepresentable,
    profileEditCheckUseCase: ProfileEditCheckUseCaseRepresentable
  ) {
    self.profileEditUseCase = profileEditUseCase
    self.profileEditCheckUseCase = profileEditCheckUseCase
  }
}

// MARK: EditProfileViewModelRepresentable

extension EditProfileViewModel: EditProfileViewModelRepresentable {
  public func transform(input: EditProfileViewModelInput) -> EditProfileViewModelOutput {
    subscriptions.removeAll()

    let userName: EditProfileViewModelOutput = input
      .loadProfileInformation
      .map { [profileEditUseCase] _ in
        let userName = profileEditUseCase.loadUserName()
        return EditProfileState.nickName(userName)
      }
      .eraseToAnyPublisher()

    let profileImage: EditProfileViewModelOutput = input.loadProfileInformation
      .compactMap { [profileEditUseCase] _ in profileEditUseCase.loadUserImageURL() }
      .map { url in return EditProfileState.profileImage(url) }
      .eraseToAnyPublisher()

    let biography: EditProfileViewModelOutput = input.loadProfileInformation
      .map { [profileEditUseCase] _ in
        let biography = profileEditUseCase.loadUserBiography()
        return EditProfileState.biography(biography)
      }
      .eraseToAnyPublisher()

    let validNickName: EditProfileViewModelOutput = input.editNickName
      .map { [profileEditCheckUseCase] text in
        if text == "" {
          return EditProfileState.emptyNickName
        }
        
        let isValid = profileEditCheckUseCase.checkNewNickname(with: text)
        if isValid {
          return EditProfileState.validNickname
        } else {
          let message = profileEditCheckUseCase.invalidNicknameMessage(with: text)
          return EditProfileState.invalidNickName(message)
        }
      }
      .eraseToAnyPublisher()

    let initialState: EditProfileViewModelOutput = Just(.idle).eraseToAnyPublisher()

    return initialState.merge(with: userName, profileImage, biography, validNickName).eraseToAnyPublisher()
  }
}
