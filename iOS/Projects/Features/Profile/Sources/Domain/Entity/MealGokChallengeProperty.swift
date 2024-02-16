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

  func mealTime() -> String {
    return "식사시간 \(stringOfAMPM()) \(formattedStartDate()) ~ \(formattedEndDate())"
  }

  /// 언제 도전을 시작했는지 yyyy. MM. dd 로 나타냅니다.
  ///
  /// ex) 2024. 02. 16
  func challengeDate() -> String {
    return Self.challengeDateDateFormatter.string(from: startTime)
  }

  func formattedStartDate() -> String {
    return Self.dateFormatter.string(from: startTime)
  }

  func formattedEndDate() -> String {
    return Self.dateFormatter.string(from: endTime)
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

  private static let challengeDateDateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy. MM. dd"

    return formatter
  }()
}
