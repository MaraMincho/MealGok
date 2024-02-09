//
//  TimerSceneViewModel.swift
//  MealTimerFeature
//
//  Created by MaraMincho on 1/31/24.
//  Copyright © 2024 com.maramincho. All rights reserved.
//

import Combine
import Foundation
import RouterFactory

// MARK: - TimerSceneViewModelInput

public struct TimerSceneViewModelInput {
  let viewDidAppear: AnyPublisher<Void, Never>
  let didTapCompleteButton: AnyPublisher<Void, Never>
  let showAlertPublisher: AnyPublisher<Void, Never>
  let didCancelChallenge: AnyPublisher<Void, Never>
}

public typealias TimerSceneViewModelOutput = AnyPublisher<TimerSceneState, Never>

// MARK: - TimerSceneState

public enum TimerSceneState {
  case idle
  case updateTimerView(TimerUseCasePropertyEntity)
  case timerDidFinish
  case showFinishConfirmAlert
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
  weak var router: StartMealTimerSceneRouterFactoriable?

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

    let completeState: TimerSceneViewModelOutput = timerUseCase
      .timerFinished()
      .map { bool in return bool ? TimerSceneState.timerDidFinish : TimerSceneState.idle }
      .eraseToAnyPublisher()
    
    let showAlertState: TimerSceneViewModelOutput = input
      .showAlertPublisher
      .map{_ in return TimerSceneState.showFinishConfirmAlert}
      .eraseToAnyPublisher()
  

    input.didTapCompleteButton
      .sink { [router] _ in
        router?.pushSuccessScene()
      }
      .store(in: &subscriptions)

    let initialState: TimerSceneViewModelOutput = Just(.idle).eraseToAnyPublisher()

    return initialState.merge(with: updateTimerLabelText, completeState, showAlertState).eraseToAnyPublisher()
  }
}
