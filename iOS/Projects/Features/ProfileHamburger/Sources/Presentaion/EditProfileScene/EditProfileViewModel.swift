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
  let didTapProfileEditButton: AnyPublisher<Void, Never>
}

public typealias EditProfileViewModelOutput = AnyPublisher<EditProfileState, Never>

// MARK: - EditProfileState

public enum EditProfileState: Equatable {
  case idle
  case nickName(String)
  case profileImage(URL)
  case profileImageData(Data)
  case biography(String)
  case invalidNickName(String)
  case validNickname
  case emptyNickname
  case pushPictureChoiceTypeSheet
  case isEnableSaveButton(Bool)
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

  /// EditField에 대해서 필요한 Subject
  private let editProfileImage: CurrentValueSubject<Data?, Never> = .init(nil)
  private let editNickName: CurrentValueSubject<String?, Never> = .init(nil)
  private let isValidNickname: CurrentValueSubject<Bool, Never> = .init(false)
  private let checkEditField: PassthroughSubject<Void, Never> = .init()
  private let isEnableSaveButtonPublisher = CurrentValueSubject<Bool, Never>(false)

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

    let prevProfileImage: EditProfileViewModelOutput = input.loadProfileInformation
      .compactMap { [profileEditUseCase] _ in profileEditUseCase.loadUserImageURL() }
      .map { url in return EditProfileState.profileImage(url) }
      .eraseToAnyPublisher()

    let biography: EditProfileViewModelOutput = input.loadProfileInformation
      .map { [profileEditUseCase] _ in
        let biography = profileEditUseCase.loadUserBiography()
        return EditProfileState.biography(biography)
      }
      .eraseToAnyPublisher()

    input.editNickName
      .sink { [weak self] text in
        self?.editNickName.send(text)
        self?.checkEditField.send()
      }
      .store(in: &subscriptions)

    let validNickName = checkEditField
      .compactMap { [weak self] _ -> EditProfileState? in
        guard let self else {
          return nil
        }
        let editNickname = editNickName.value
        return checkEditNickname(with: editNickname)
      }

    let pushPictureChoiceType: EditProfileViewModelOutput = input
      .didTapProfileEditButton
      .map { _ in return EditProfileState.pushPictureChoiceTypeSheet }
      .eraseToAnyPublisher()

    let newProfileImage = input
      .editImage
      .map { [weak self] data in
        self?.checkEditField.send()
        return EditProfileState.profileImageData(data)
      }
      .eraseToAnyPublisher()

    let isEnableSaveButton = isEnableSaveButtonPublisher.map { EditProfileState.isEnableSaveButton($0) }

    // chcekEditField
    checkEditField
      .sink { [weak self] _ in
        guard let self else {
          self?.isEnableSaveButtonPublisher.send(false)
          return
        }
        let nickname = editNickName.value
        let editImage = editProfileImage.value
        if
          (isValidNickname(with: nickname) == true) ||
          (editNickName.value == "" && editImage != nil) {
          isEnableSaveButtonPublisher.send(true)
          return
        }
        isEnableSaveButtonPublisher.send(false)
      }
      .store(in: &subscriptions)

    let initialState: EditProfileViewModelOutput = Just(.idle).eraseToAnyPublisher()

    return initialState.merge(with: userName, prevProfileImage, biography, validNickName, pushPictureChoiceType, newProfileImage, isEnableSaveButton).eraseToAnyPublisher()
  }
}

private extension EditProfileViewModel {
  func checkEditNickname(with nickname: String?) -> EditProfileState? {
    guard let nickname else { return nil }

    if nickname == "" {
      return .emptyNickname
    }
    if !profileEditCheckUseCase.checkNewNickname(with: nickname) {
      let message = profileEditCheckUseCase.invalidNicknameMessage(with: nickname)
      return .invalidNickName(message)
    }

    return .validNickname
  }

  func isValidNickname(with nickname: String?) -> Bool {
    guard let nickname else { return false }
    if !profileEditCheckUseCase.checkNewNickname(with: nickname) {
      return false
    }
    return true
  }
}
