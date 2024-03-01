//
//  ProfileEditRepository.swift
//  ProfileHamburgerFeature
//
//  Created by MaraMincho on 3/1/24.
//  Copyright © 2024 com.maramincho. All rights reserved.
//

import Foundation
import MealGokCacher

final class ProfileEditRepository: ProfileEditRepositoryRepresentable {
  private let userDefaults = UserDefaults.standard
  
  //MARK: - Fetch
  func userName() -> String? {
    return userDefaults.string(forKey: Constants.nameKey)
  }

  func profileImageURL() -> URL? {
    return MealGokCacher.url(fileName: Constants.profileImageURLKey)
  }

  func userBiography() -> String? {
    return userDefaults.string(forKey: Constants.biographyKey)
  }
  
  //MARK: - Save
  func saveNickName(with name: String) {
    userDefaults.set(name, forKey: Constants.nameKey)
  }
  
  func saveUserImage(with data: Data) {
    guard let url = profileImageURL() else {
      return
    }
    
    // TODO: 만약 특정 로직 추가하여 에러를 핸들링 해도 좋을 것 같음
    try? data.write(to: url)
  }
  
  func saveBioGraphy(with biography: String) {
    userDefaults.set(biography, forKey: Constants.biographyKey)
  }
  
  private enum Constants {
    static let nameKey = "MealGokName"
    static let profileImageURLKey = "MealGokProfileImage"
    static let biographyKey = "MealGokBiography"
  }
}
