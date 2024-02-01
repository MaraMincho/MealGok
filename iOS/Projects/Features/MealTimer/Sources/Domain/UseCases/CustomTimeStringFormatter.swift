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
  let totalSeconds: Int
  let updateIntervalRadian: Double
  var prevPortionRadian: Double

  let numberFormatter: NumberFormatter = {
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
    let fanRadian: Double?
    let currentRadian = (Double(target) / Double(totalSeconds)) * Double.pi * 2
    if currentRadian >= prevPortionRadian {
      while currentRadian >= prevPortionRadian {
        prevPortionRadian += updateIntervalRadian
      }
      fanRadian = prevPortionRadian
    } else {
      fanRadian = nil
    }

    return .init(
      minute: numberFormatter.string(for: minutesString) ?? "",
      seconds: numberFormatter.string(for: secondsString) ?? "",
      fanRadian: fanRadian
    )
  }

  init(minutes: Int, seconds: Int = 0, totalUpdateCount: Int = 120) {
    totalSeconds = minutes * 60 + seconds
    let secondsRadian = 2 * Double.pi / Double(totalSeconds)
    let userSettingRadian = 2 * Double.pi / Double(totalUpdateCount)
    updateIntervalRadian = secondsRadian > userSettingRadian ? secondsRadian : userSettingRadian
    prevPortionRadian = updateIntervalRadian
  }
}
