//
//  ProfileEditCheckUseCase.swift
//  ProfileHamburgerFeature
//
//  Created by MaraMincho on 3/1/24.
//  Copyright © 2024 com.maramincho. All rights reserved.
//

import Foundation

// MARK: - ProfileEditCheckUseCaseRepresentable

protocol ProfileEditCheckUseCaseRepresentable {
  func checkNewNickName(with nickName: String) -> Bool
}

// MARK: - ProfileEditCheckUseCase

final class ProfileEditCheckUseCase: ProfileEditCheckUseCaseRepresentable {
  let nickNameRegex = /^[\w|\-|\_|가-힣]{2,12}$/

  func checkNewNickName(with nickName: String) -> Bool {
    guard let matchString = nickName.firstMatch(of: nickNameRegex) else {
      return false
    }
    return true
  }
}
