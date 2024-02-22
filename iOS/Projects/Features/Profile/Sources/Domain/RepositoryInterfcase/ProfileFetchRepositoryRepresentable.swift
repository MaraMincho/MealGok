//
//  ProfileFetchRepositoryRepresentable.swift
//  ProfileFeature
//
//  Created by MaraMincho on 2/22/24.
//  Copyright © 2024 com.maramincho. All rights reserved.
//

import Foundation

protocol ProfileFetchRepositoryRepresentable {
  func userName() -> String?
  func profileImageURL() -> URL?
  func userBiography() -> String?
}
