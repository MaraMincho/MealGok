//
//  ProfileEditRepositoryRepresentable.swift
//  ProfileHamburgerFeature
//
//  Created by MaraMincho on 3/1/24.
//  Copyright © 2024 com.maramincho. All rights reserved.
//

import Foundation

protocol ProfileEditRepositoryRepresentable {
  func userName() -> String?
  func profileImageURL() -> URL?
  func userBiography() -> String?
  
  
  func saveNickName(with name: String)
  func saveUserImage(with data: Data)
  func saveBioGraphy(with biography: String)
}
