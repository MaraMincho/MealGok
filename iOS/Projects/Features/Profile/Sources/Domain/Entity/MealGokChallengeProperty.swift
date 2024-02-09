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
}
