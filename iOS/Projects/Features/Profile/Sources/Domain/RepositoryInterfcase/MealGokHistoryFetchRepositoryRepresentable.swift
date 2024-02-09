//
//  MealGokHistoryFetchRepositoryRepresentable.swift
//  ProfileFeature
//
//  Created by MaraMincho on 2/8/24.
//  Copyright © 2024 com.maramincho. All rights reserved.
//

import Foundation

protocol MealGokHistoryFetchRepositoryRepresentable {
  func fetch(dateString: String) -> [MealGokChallengeProperty]
  func fetchAllHistory() -> [MealGokChallengeProperty]
}
