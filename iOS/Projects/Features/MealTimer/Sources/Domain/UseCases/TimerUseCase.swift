//
//  TimerUseCase.swift
//  MealTimerFeature
//
//  Created by MaraMincho on 1/31/24.
//  Copyright © 2024 com.maramincho. All rights reserved.
//

import Combine
import Foundation

// MARK: - TimerUseCasesRepresentable

protocol TimerUseCasesRepresentable {
  func timerLabelText() -> AnyPublisher<TimerUseCasePropertyEntity, Never>
  func start()
}

// MARK: - TimerUseCase

final class TimerUseCase: TimerUseCasesRepresentable {
  private var oneSecondsTimer = Timer.publish(every: 1, on: .main, in: .common)

  private var startTime: Date? = nil

  private let customStringFormatter: CustomTimeStringFormatter

  init(customStringFormatter: CustomTimeStringFormatter) {
    self.customStringFormatter = customStringFormatter
  }

  func timerLabelText() -> AnyPublisher<TimerUseCasePropertyEntity, Never> {
    return oneSecondsTimer.autoconnect()
      .compactMap { [weak self] val -> TimerUseCasePropertyEntity? in
        guard
          let self,
          let startTime
        else {
          return nil
        }
        let from = val.timeIntervalSince(startTime)
        return customStringFormatter.subtract(from: from)
      }.eraseToAnyPublisher()
  }

  func start() {
    startTime = Date.now
  }
}
