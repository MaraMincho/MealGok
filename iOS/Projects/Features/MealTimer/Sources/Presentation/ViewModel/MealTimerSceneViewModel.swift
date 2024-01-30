//
//  MealTimerSceneViewModel.swift
//  MealTimerFeature
//
//  Created by MaraMincho on 1/30/24.
//  Copyright © 2024 com.maramincho. All rights reserved.
//

import Combine
import Foundation

// MARK: - MealTimerSceneViewModelInput

public struct MealTimerSceneViewModelInput {}

public typealias MealTimerSceneViewModelOutput = AnyPublisher<MealTimerSceneState, Never>

// MARK: - MealTimerSceneState

public enum MealTimerSceneState {
  case idle
}

// MARK: - MealTimerSceneViewModelRepresentable

protocol MealTimerSceneViewModelRepresentable {
  func transform(input: MealTimerSceneViewModelInput) -> MealTimerSceneViewModelOutput
}

// MARK: - MealTimerSceneViewModel

final class MealTimerSceneViewModel {
  // MARK: - Properties

  private var subscriptions: Set<AnyCancellable> = []
}

// MARK: MealTimerSceneViewModelRepresentable

extension MealTimerSceneViewModel: MealTimerSceneViewModelRepresentable {
  public func transform(input _: MealTimerSceneViewModelInput) -> MealTimerSceneViewModelOutput {
    subscriptions.removeAll()

    let initialState: MealTimerSceneViewModelOutput = Just(.idle).eraseToAnyPublisher()

    return initialState
  }
}
