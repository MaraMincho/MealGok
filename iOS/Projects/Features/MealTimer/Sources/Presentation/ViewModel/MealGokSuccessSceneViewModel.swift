//
//  MealGokSuccessSceneViewModel.swift
//  MealTimerFeature
//
//  Created by MaraMincho on 2/1/24.
//  Copyright © 2024 com.maramincho. All rights reserved.
//

import Combine
import Foundation

// MARK: - MealGokSuccessSceneViewModelInput

public struct MealGokSuccessSceneViewModelInput {}

public typealias MealGokSuccessSceneViewModelOutput = AnyPublisher<MealGokSuccessSceneState, Never>

// MARK: - MealGokSuccessSceneState

public enum MealGokSuccessSceneState {
  case idle
}

// MARK: - MealGokSuccessSceneViewModelRepresentable

protocol MealGokSuccessSceneViewModelRepresentable {
  func transform(input: MealGokSuccessSceneViewModelInput) -> MealGokSuccessSceneViewModelOutput
}

// MARK: - MealGokSuccessSceneViewModel

final class MealGokSuccessSceneViewModel {
  // MARK: - Properties

  private var subscriptions: Set<AnyCancellable> = []
}

// MARK: MealGokSuccessSceneViewModelRepresentable

extension MealGokSuccessSceneViewModel: MealGokSuccessSceneViewModelRepresentable {
  public func transform(input _: MealGokSuccessSceneViewModelInput) -> MealGokSuccessSceneViewModelOutput {
    subscriptions.removeAll()

    let initialState: MealGokSuccessSceneViewModelOutput = Just(.idle).eraseToAnyPublisher()

    return initialState
  }
}
