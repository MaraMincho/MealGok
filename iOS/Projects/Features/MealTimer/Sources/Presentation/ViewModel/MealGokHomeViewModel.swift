//
//  MealGokHomeViewModel.swift
//  MealTimerFeature
//
//  Created by MaraMincho on 1/30/24.
//  Copyright © 2024 com.maramincho. All rights reserved.
//

import Combine
import Foundation
import RouterFactory

// MARK: - MealGokHomeViewModelInput

public struct MealGokHomeViewModelInput {
  let didCameraButtonTouchPublisher: AnyPublisher<Void, Never>
  let didTimerStartButtonTouchPublisher: AnyPublisher<Void, Never>
}

public typealias MealGokHomeViewModelOutput = AnyPublisher<MealGokHomeState, Never>

// MARK: - MealGokHomeState

public enum MealGokHomeState {
  case idle
  case presentCamera
}

// MARK: - MealTimerSceneViewModelRepresentable

protocol MealTimerSceneViewModelRepresentable {
  func transform(input: MealGokHomeViewModelInput) -> MealGokHomeViewModelOutput
}

// MARK: - MealGokHomeViewModel

final class MealGokHomeViewModel {
  // MARK: - Properties

  private var subscriptions: Set<AnyCancellable> = []
  weak var router: MealGokHomeFactoriable?
}

// MARK: MealTimerSceneViewModelRepresentable

extension MealGokHomeViewModel: MealTimerSceneViewModelRepresentable {
  public func transform(input: MealGokHomeViewModelInput) -> MealGokHomeViewModelOutput {
    subscriptions.removeAll()

    input.didTimerStartButtonTouchPublisher
      .sink { [router] _ in
        router?.startMealTimerScene()
      }
      .store(in: &subscriptions)

    let presentCameraPicker = input.didCameraButtonTouchPublisher
      .map { _ in return MealGokHomeState.presentCamera }
      .eraseToAnyPublisher()

    let initialState: MealGokHomeViewModelOutput = Just(.idle).eraseToAnyPublisher()

    return initialState.merge(with: presentCameraPicker).eraseToAnyPublisher()
  }
}
