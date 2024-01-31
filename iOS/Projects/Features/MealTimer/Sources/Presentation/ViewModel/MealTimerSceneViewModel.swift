//
//  MealTimerSceneViewModel.swift
//  MealTimerFeature
//
//  Created by MaraMincho on 1/30/24.
//  Copyright © 2024 com.maramincho. All rights reserved.
//

import Combine
import Foundation
import RouterFactory

// MARK: - MealTimerSceneViewModelInput

public struct MealTimerSceneViewModelInput {
  let didCameraButtonTouchPublisher: AnyPublisher<Void, Never>
  let didTimerStartButtonTouchPublisher: AnyPublisher<Void, Never>
}

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
  weak var router: MealTimerSceneRouterFactoriable?
}

// MARK: MealTimerSceneViewModelRepresentable

extension MealTimerSceneViewModel: MealTimerSceneViewModelRepresentable {
  public func transform(input: MealTimerSceneViewModelInput) -> MealTimerSceneViewModelOutput {
    subscriptions.removeAll()

    input.didTimerStartButtonTouchPublisher
      .sink { [router] _ in
        router?.startMealTimerScene()
      }
      .store(in: &subscriptions)

    let initialState: MealTimerSceneViewModelOutput = Just(.idle).eraseToAnyPublisher()

    return initialState
  }
}
