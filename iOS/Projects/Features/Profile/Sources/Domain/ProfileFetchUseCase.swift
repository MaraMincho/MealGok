//
//  ProfileFetchUseCase.swift
//  ProfileFeature
//
//  Created by MaraMincho on 2/22/24.
//  Copyright © 2024 com.maramincho. All rights reserved.
//

import Foundation

// MARK: - ProfileFetchUseCaseRepresentable

protocol ProfileFetchUseCaseRepresentable {
  func loadUserName() -> String

  func loadUserImageURL() -> URL?

  func loadUserBiography() -> String
}

// MARK: - ProfileFetchUseCase

final class ProfileFetchUseCase: ProfileFetchUseCaseRepresentable {
  private let profileFetchRepository: ProfileFetchRepositoryRepresentable

  func loadUserName() -> String {
    return profileFetchRepository.userName() ?? "꼭꼭이"
  }

  func loadUserImageURL() -> URL? {
    return profileFetchRepository.profileImageURL()
  }

  func loadUserBiography() -> String {
    return profileFetchRepository.userBiography() ?? "안녕하세요 좋은 아침"
  }

  init(profileFetchRepository: ProfileFetchRepositoryRepresentable) {
    self.profileFetchRepository = profileFetchRepository
  }
}
