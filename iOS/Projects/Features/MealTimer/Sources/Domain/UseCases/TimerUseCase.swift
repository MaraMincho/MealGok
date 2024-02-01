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
  func timerLabelText() -> AnyPublisher<String, Never>
  func start()
}

// MARK: - TimerUseCase

final class TimerUseCase: TimerUseCasesRepresentable {
  private var oneSecondsTimer = Timer.publish(every: 1, on: .main, in: .common)

  private var startTime: Date? = .now + 1

  private let customStringFormatter: CustomTimeStringFormatter

  init(customStringFormatter: CustomTimeStringFormatter) {
    self.customStringFormatter = customStringFormatter
  }

  func timerLabelText() -> AnyPublisher<String, Never> {
    return oneSecondsTimer.autoconnect()
      .compactMap { [startTime, customStringFormatter] val -> String? in
        guard let startTime else {
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

// MARK: - CustomTimeStringFormatter

struct CustomTimeStringFormatter {
  let totalSeconds: Int

  let numberFormatter: NumberFormatter = {
    let formatter = NumberFormatter()
    formatter.minimumIntegerDigits = 2

    return formatter
  }()

  func subtract(from: Double) -> String {
    let target = Int(from)
    let leftSeconds = totalSeconds - target
    let secondsString = leftSeconds % 60
    let minutesString = leftSeconds / 60
    return "\(numberFormatter.string(for: minutesString) ?? "0"):\(numberFormatter.string(for: secondsString) ?? "0")"
  }

  init(totalSeconds: Int) {
    self.totalSeconds = totalSeconds
  }

  init(totalMinutes: Int) {
    totalSeconds = totalMinutes * 60
  }
}
