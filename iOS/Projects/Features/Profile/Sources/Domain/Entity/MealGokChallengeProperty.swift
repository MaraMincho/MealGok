//
//  MealGokChallengeProperty.swift
//  ProfileFeature
//
//  Created by MaraMincho on 2/8/24.
//  Copyright © 2024 com.maramincho. All rights reserved.
//

import Foundation

public struct MealGokChallengeProperty: Hashable {
  let challengeDateString: String
  let endTime: Date
  let startTime: Date
  let imageDateURL: String?
  let isSuccess: Bool

  func formattedStartDate() -> String {
    return Self.dateFormatter.string(from: startTime)
  }

  func formattedEndDate() -> String {
    return Self.dateFormatter.string(from: startTime)
  }

  func stringOfAMPM() -> String {
    return Self.AMPMFormatter.string(from: startTime)
  }

  func challengeDurationTime() -> (minutes: Int, seconds: Int) {
    let timeInterval = endTime.timeIntervalSince(startTime)
    let minutes = Int(timeInterval / 60)
    let seconds = Int(Int(timeInterval) % 60)

    return (minutes, seconds)
  }

  private static let AMPMFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "a"

    return formatter
  }()

  private static let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "HH:mm"

    return formatter
  }()
}
