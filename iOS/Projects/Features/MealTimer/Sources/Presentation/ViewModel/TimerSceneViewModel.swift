//
//  TimerSceneViewModel.swift
//  MealTimerFeature
//
//  Created by MaraMincho on 1/31/24.
//  Copyright © 2024 com.maramincho. All rights reserved.
//

import Combine
import Foundation

// MARK: - TimerSceneViewModelInput

public struct TimerSceneViewModelInput {
  var viewDidAppear: AnyPublisher<Void, Never>
}

public typealias TimerSceneViewModelOutput = AnyPublisher<TimerSceneState, Never>

// MARK: - TimerSceneState

public enum TimerSceneState {
  case idle
  case updateTimerView(TimerUseCasePropertyEntity)
}

// MARK: - TimerSceneViewModelRepresentable

protocol TimerSceneViewModelRepresentable {
  func transform(input: TimerSceneViewModelInput) -> TimerSceneViewModelOutput
}

// MARK: - TimerSceneViewModel

final class TimerSceneViewModel {
  // MARK: - Properties

  private var timerUseCase: TimerUseCasesRepresentable
  private var subscriptions: Set<AnyCancellable> = []

  init(timerUseCase: TimerUseCasesRepresentable) {
    self.timerUseCase = timerUseCase
  }
}

// MARK: TimerSceneViewModelRepresentable

extension TimerSceneViewModel: TimerSceneViewModelRepresentable {
  public func transform(input: TimerSceneViewModelInput) -> TimerSceneViewModelOutput {
    subscriptions.removeAll()

    input.viewDidAppear
      .sink { [timerUseCase] in
        timerUseCase.start()
      }
      .store(in: &subscriptions)

    let updateTimerLabelText: TimerSceneViewModelOutput = timerUseCase
      .timerLabelText()
      .map { entity in
        return TimerSceneState.updateTimerView(entity)
      }.eraseToAnyPublisher()

    let initialState: TimerSceneViewModelOutput = Just(.idle).eraseToAnyPublisher()

    return initialState.merge(with: updateTimerLabelText).eraseToAnyPublisher()
  }
}
