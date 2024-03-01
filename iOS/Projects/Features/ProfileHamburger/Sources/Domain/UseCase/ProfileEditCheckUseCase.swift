//
//  ProfileEditCheckUseCase.swift
//  ProfileHamburgerFeature
//
//  Created by MaraMincho on 3/1/24.
//  Copyright © 2024 com.maramincho. All rights reserved.
//

import Foundation

protocol ProfileEditCheckUseCaseRepresentable {
  
}

final class ProfileEditCheckUseCase: ProfileEditCheckUseCaseRepresentable {
  let nickNameRegex = /^[\w|\-|\_|가-힣]{2,12}$/
}
