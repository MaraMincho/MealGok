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
  private let isFinished: CurrentValueSubject<Bool, Never> = .init(false)
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

    timerUseCase
      .timerFinished()
      .sink { [weak self] bool in
        self?.isFinished.send(bool)
      }
      .store(in: &subscriptions)

    let completeState: TimerSceneViewModelOutput = isFinished
      .map { bool in return bool ? TimerSceneState.timerDidFinish : TimerSceneState.idle }
      .eraseToAnyPublisher()

    let showAlertState: TimerSceneViewModelOutput = input
      .showAlertPublisher
      .map { _ in return TimerSceneState.showFinishConfirmAlert }
      .eraseToAnyPublisher()

    input.didTapCompleteButton
      .compactMap { [weak self] _ -> Void? in
        // 만약 타이머가 종료 되었다면, 이벤트를 무시하고, 종료되었다면 state를 전달합니다.
        return self?.isFinished.value == true ? () : nil
      }
      .sink { [router] _ in
        router?.pushSuccessScene()
      }
      .store(in: &subscriptions)

    input.didCancelChallenge
      .sink { [weak self] _ in
        self?.timerUseCase.cancelChallenge()
        self?.router?.pushSuccessScene()
      }
      .store(in: &subscriptions)

    let initialState: TimerSceneViewModelOutput = Just(.idle).eraseToAnyPublisher()

    return initialState.merge(with: updateTimerLabelText, completeState, showAlertState).eraseToAnyPublisher()
  }
}
