//
//  ProfileEditUseCase.swift
//  ProfileHamburgerFeature
//
//  Created by MaraMincho on 3/1/24.
//  Copyright © 2024 com.maramincho. All rights reserved.
//

import Foundation

// MARK: - ProfileEditUseCaseRepresentable

protocol ProfileEditUseCaseRepresentable {
  func loadUserName() -> String
  func loadUserImageURL() -> URL?
  func loadUserBiography() -> String

  func saveNewNickName(with: String)
  func saveNewUserImage(with: Data)
  func saveNewBioGraphy(with: String)
}

// MARK: - ProfileEditUseCase

final class ProfileEditUseCase: ProfileEditUseCaseRepresentable {
  private let profileEditRepository: ProfileEditRepositoryRepresentable

  func loadUserName() -> String {
    return profileEditRepository.userName() ?? "밀꼭이"
  }

  func loadUserImageURL() -> URL? {
    return profileEditRepository.profileImageURL()
  }

  func loadUserBiography() -> String {
    return profileEditRepository.userBiography() ?? "안녕하세요 좋은 아침"
  }

  func saveNewNickName(with name: String) {
    profileEditRepository.saveNickName(with: name)
  }

  func saveNewBioGraphy(with biography: String) {
    profileEditRepository.saveBioGraphy(with: biography)
  }

  func saveNewUserImage(with data: Data) {
    profileEditRepository.saveUserImage(with: data)
  }

  init(profileEditRepository: ProfileEditRepositoryRepresentable) {
    self.profileEditRepository = profileEditRepository
  }
}
