//
//  TargetTimeUseCase.swift
//  MealTimerFeature
//
//  Created by MaraMincho on 2/7/24.
//  Copyright © 2024 com.maramincho. All rights reserved.
//

import Foundation

// MARK: - TargetTimeUseCaseRepresentable

protocol TargetTimeUseCaseRepresentable {
  func targetTime() -> Int
  func saveTargetTime(_ value: Int)
}

// MARK: - TargetTimeUseCase

final class TargetTimeUseCase {
  private let repository: TargetTimeRepositoryRepresentable
  init(repository: TargetTimeRepositoryRepresentable) {
    self.repository = repository
  }
}

// MARK: TargetTimeUseCaseRepresentable

extension TargetTimeUseCase: TargetTimeUseCaseRepresentable {
  func saveTargetTime(_ value: Int) {
    repository.saveTargetTime(value)
  }

  func targetTime() -> Int {
    let targetTimeValue = repository.targetTime()
    return checkTargetTime(targetTimeValue)
  }

  private func checkTargetTime(_ targetTime: Int) -> Int {
    if targetTime < 10 || targetTime > 20 {
      return 10
    }
    return targetTime
  }
}
