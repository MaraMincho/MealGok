//
//  PrevChallengeLoadUseCase.swift
//  MealTimerFeature
//
//  Created by MaraMincho on 2/20/24.
//  Copyright © 2024 com.maramincho. All rights reserved.
//

import Foundation

// MARK: - PrevChallengeLoadUseCaseRepresentable

protocol PrevChallengeLoadUseCaseRepresentable {
  func checkPrevChallenge() -> PrevChallengeSupportState
}

// MARK: - PrevChallengeLoadUseCase

final class PrevChallengeLoadUseCase: PrevChallengeLoadUseCaseRepresentable {
  let loader: PrevChallengeManageable

  init(loader: PrevChallengeManageable) {
    self.loader = loader
  }

  func checkPrevChallenge() -> PrevChallengeSupportState {
    guard
      let startDate = loader.prevChallengeStartDate(),
      let totalSeconds = loader.prevChallengeTotalSeconds()
    else {
      return .idle
    }
    let now = Date.now
    let prevFinishDate = startDate.addingTimeInterval(Double(totalSeconds))
    let subtractValue = now.timeIntervalSince(prevFinishDate)

    if subtractValue < 0 { // 아직 챌린지가 끝나지 않았다면
      let targetMinutes = totalSeconds / 60
      return .timer(targetMinutes: targetMinutes, startDate: startDate)
    } else if subtractValue < 600 { // 챌린지가 끝났고, 10분 이내라면
      let targetMinutes = totalSeconds / 60
      return .successChallenge(targetMinutes: targetMinutes, startDate: startDate)
    } else { // 10분이 넘어 버린 경우
      return .idle
    }
  }
}

// MARK: - PrevChallengeSupportState

enum PrevChallengeSupportState {
  case timer(targetMinutes: Int, startDate: Date)
  case successChallenge(targetMinutes: Int, startDate: Date)
  case idle
}
