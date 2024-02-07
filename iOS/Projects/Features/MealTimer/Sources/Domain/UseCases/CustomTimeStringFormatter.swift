//
//  CustomTimeStringFormatter.swift
//  MealTimerFeature
//
//  Created by MaraMincho on 2/1/24.
//  Copyright © 2024 com.maramincho. All rights reserved.
//

import Foundation

// MARK: - CustomTimeStringFormatter

final class CustomTimeStringFormatter {
  private let totalSeconds: Int

  private let numberFormatter: NumberFormatter = {
    let formatter = NumberFormatter()
    formatter.minimumIntegerDigits = 2

    return formatter
  }()

  func subtract(from: Double) -> TimerUseCasePropertyEntity? {
    let target = Int(from)
    let leftSeconds = totalSeconds - target

    if leftSeconds < 0 {
      return nil
    }

    let secondsString = leftSeconds % 60
    let minutesString = leftSeconds / 60

    let currentRadian = (Double(target) / Double(totalSeconds)) * Double.pi * 2

    return .init(
      minute: numberFormatter.string(for: minutesString) ?? "",
      seconds: numberFormatter.string(for: secondsString) ?? "",
      fanRadian: currentRadian
    )
  }

  func start() -> TimerUseCasePropertyEntity {
    let secondsString = numberFormatter.string(for: totalSeconds % 60) ?? ""
    let minutesString = numberFormatter.string(for: totalSeconds / 60) ?? ""
    return .init(minute: minutesString, seconds: secondsString, fanRadian: nil)
  }

  init(minutes: Int, seconds: Int = 0) {
    totalSeconds = minutes * 60 + seconds
    let secondsRadian = 2 * Double.pi / Double(totalSeconds)
  }
}
