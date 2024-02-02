//
//  MealGokSuccessSceneViewModel.swift
//  MealTimerFeature
//
//  Created by MaraMincho on 2/1/24.
//  Copyright © 2024 com.maramincho. All rights reserved.
//

import Combine
import Foundation
import RouterFactory

// MARK: - MealGokSuccessSceneViewModelInput

public struct MealGokSuccessSceneViewModelInput {
  let shareButtonDidTap: AnyPublisher<Void, Never>
  let goHomeButtonDidTap: AnyPublisher<Void, Never>
}

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

  weak var router: MealGokSuccessSceneRouter?
  private var subscriptions: Set<AnyCancellable> = []
}

// MARK: MealGokSuccessSceneViewModelRepresentable

extension MealGokSuccessSceneViewModel: MealGokSuccessSceneViewModelRepresentable {
  public func transform(input: MealGokSuccessSceneViewModelInput) -> MealGokSuccessSceneViewModelOutput {
    subscriptions.removeAll()

    input.goHomeButtonDidTap
      .sink { [router] _ in
        router?.goHome()
      }.store(in: &subscriptions)

    let initialState: MealGokSuccessSceneViewModelOutput = Just(.idle).eraseToAnyPublisher()

    return initialState
  }
}
