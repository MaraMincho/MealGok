//
//  ProfileEditUseCase.swift
//  ProfileHamburgerFeature
//
//  Created by MaraMincho on 3/1/24.
//  Copyright © 2024 com.maramincho. All rights reserved.
//

import Foundation

protocol ProfileEditUseCaseRepresentable {
  func loadUserName() -> String
  func loadUserImageURL() -> URL?
  func loadUserBiography() -> String
}

final class ProfileEditUseCase {
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

  init(profileEditRepository: ProfileEditRepositoryRepresentable) {
    self.profileEditRepository = profileEditRepository
  }
}
