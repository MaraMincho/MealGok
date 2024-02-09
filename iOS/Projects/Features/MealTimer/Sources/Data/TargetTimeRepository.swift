//
//  TargetTimeRepository.swift
//  MealTimerFeature
//
//  Created by MaraMincho on 2/7/24.
//  Copyright © 2024 com.maramincho. All rights reserved.
//

import Foundation

struct TargetTimeRepository: TargetTimeRepositoryRepresentable {
  private let userDefaults: UserDefaults = .standard

  func saveTargetTime(_ targetTimeValue: Int) {
    userDefaults.set(targetTimeValue, forKey: UserDefaultsKey.targetTimeKey)
  }

  /// targetTime을 가져오는 함수입니다.
  ///
  /// 만약 targetTime의 key가 없다면, 0을 리턴합니다.
  func targetTime() -> Int {
    return userDefaults.integer(forKey: UserDefaultsKey.targetTimeKey)
  }

  private enum UserDefaultsKey {
    static let targetTimeKey = "TargetTimeKey"
  }

  init() {}
}
