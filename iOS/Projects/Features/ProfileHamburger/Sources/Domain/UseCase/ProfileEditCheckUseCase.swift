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
  func checkNewNickname(with nickName: String) -> Bool
  func invalidNicknameMessage(with nickname: String) -> String
}

// MARK: - ProfileEditCheckUseCase

final class ProfileEditCheckUseCase: ProfileEditCheckUseCaseRepresentable {
  func invalidNicknameMessage(with _: String) -> String {
    return "2글자에서 12글자 사이의 -, _, 한글 그리고 영어"
  }

  let nickNameRegex = /^[\w|\-|\_|가-힣]{2,12}$/

  func checkNewNickname(with nickName: String) -> Bool {
    return nickName.firstMatch(of: nickNameRegex) == nil ? false : true
  }
}
