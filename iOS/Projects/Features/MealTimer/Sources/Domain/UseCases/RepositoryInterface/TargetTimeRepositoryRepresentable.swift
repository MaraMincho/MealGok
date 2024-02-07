//
//  TargetTimeRepositoryRepresentable.swift
//  MealTimerFeature
//
//  Created by MaraMincho on 2/7/24.
//  Copyright © 2024 com.maramincho. All rights reserved.
//

import Foundation

protocol TargetTimeRepositoryRepresentable {
  func targetTime() -> Int
  func saveTargetTime(_ value: Int)
}
