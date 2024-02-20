//
//  PrevChallengeSaveUseCase.swift
//  MealTimerFeature
//
//  Created by MaraMincho on 2/20/24.
//  Copyright © 2024 com.maramincho. All rights reserved.
//

import Foundation

// MARK: - PrevChallengeWriteUseCaseRepresentable

protocol PrevChallengeWriteUseCaseRepresentable {
  func setPrevChallengeStartDate(_ date: Date)
  func setPrevChallengeTotalSeconds(_ value: Int)
}

// MARK: - PrevChallengeWriteUseCase

final class PrevChallengeWriteUseCase: PrevChallengeWriteUseCaseRepresentable {
  let prevChallengeWriteRepository: PrevChallengeWriteManageable
  init(prevChallengeWriteRepository: PrevChallengeWriteManageable) {
    self.prevChallengeWriteRepository = prevChallengeWriteRepository
  }

  func setPrevChallengeStartDate(_ date: Date) {
    prevChallengeWriteRepository.setPrevChallengeStartDate(date)
  }

  func setPrevChallengeTotalSeconds(_ value: Int) {
    prevChallengeWriteRepository.setPrevChallengeTotalSeconds(value)
  }
}
