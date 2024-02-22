//
//  ProfileFetchRepository.swift
//  ProfileFeature
//
//  Created by MaraMincho on 2/22/24.
//  Copyright © 2024 com.maramincho. All rights reserved.
//

import Foundation
import MealGokCacher

final class ProfileFetchRepository: ProfileFetchRepositoryRepresentable {
  private let userDefaults = UserDefaults.standard
  
  func userName() -> String? {
    return userDefaults.string(forKey: Constants.nameKey)
  }
  
  func profileImageURL() -> URL? {
    return MealGokCacher.url(fileName: Constants.profileImageURLKey)
  }
  
  func userBiography() -> String? {
    return userDefaults.string(forKey: Constants.biographyKey)
  }
  
  private enum Constants {
    static let nameKey = "MealGokName"
    static let profileImageURLKey = "MealGokProfileImage"
    static let biographyKey = "MealGokBiography"
  }
  
}
