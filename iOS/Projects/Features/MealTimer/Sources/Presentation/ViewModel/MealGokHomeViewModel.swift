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
  let needUpdateTargetTimePublisher: AnyPublisher<Void, Never>
  let saveTargetTimePublisher: AnyPublisher<Int, Never>
}

public typealias MealGokHomeViewModelOutput = AnyPublisher<MealGokHomeState, Never>

// MARK: - MealGokHomeState

public enum MealGokHomeState {
  case idle
  case presentCamera
  case targetTime(value: Int)
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
  private let targetTimeUseCase: TargetTimeUseCaseRepresentable

  init(targetTimeUseCase: TargetTimeUseCaseRepresentable) {
    self.targetTimeUseCase = targetTimeUseCase
  }
}

// MARK: MealTimerSceneViewModelRepresentable

extension MealGokHomeViewModel: MealTimerSceneViewModelRepresentable {
  public func transform(input: MealGokHomeViewModelInput) -> MealGokHomeViewModelOutput {
    subscriptions.removeAll()

    input.didTimerStartButtonTouchPublisher
      .sink { [targetTimeUseCase, router] _ in
        router?.startMealTimerScene(targetMinute: targetTimeUseCase.targetTime())
      }
      .store(in: &subscriptions)

    let presentCameraPicker = input.didCameraButtonTouchPublisher
      .map { _ in return MealGokHomeState.presentCamera }
      .eraseToAnyPublisher()

    let targetTimeState: MealGokHomeViewModelOutput = input.needUpdateTargetTimePublisher
      .compactMap { [weak self] _ in
        guard let targetTime = self?.targetTimeUseCase.targetTime() else {
          return nil
        }
        return MealGokHomeState.targetTime(value: targetTime)
      }.eraseToAnyPublisher()

    input.saveTargetTimePublisher.sink { [weak self] value in
      self?.targetTimeUseCase.saveTargetTime(value)
    }
    .store(in: &subscriptions)

    let initialState: MealGokHomeViewModelOutput = Just(.idle).eraseToAnyPublisher()

    return initialState.merge(with: presentCameraPicker, targetTimeState).eraseToAnyPublisher()
  }
}
