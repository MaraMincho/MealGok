//
//  ProfileFetchUseCase.swift
//  ProfileFeature
//
//  Created by MaraMincho on 2/22/24.
//  Copyright © 2024 com.maramincho. All rights reserved.
//

import Foundation

protocol ProfileFetchUseCaseRepresentable {
  
}

final class ProfileFetchUseCase: ProfileFetchUseCaseRepresentable {
  private let profileFetchRepository: ProfileFetchRepositoryRepresentable
  
  func loadUserName() -> String {
    return profileFetchRepository.userName() ?? ""
  }
  
  func loadUserImageURL() -> URL? {
    return profileFetchRepository.profileImageURL()
  }
  
  func loadUserBiography() -> String {
    return profileFetchRepository.userBiography() ?? ""
  }
  
  init(profileFetchRepository: ProfileFetchRepositoryRepresentable) {
    self.profileFetchRepository = profileFetchRepository
  }
}
