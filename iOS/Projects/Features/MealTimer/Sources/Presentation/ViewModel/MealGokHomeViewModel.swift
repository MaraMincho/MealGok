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
  let startTimeScenePublisher: AnyPublisher<Data?, Never>
  let needUpdateTargetTimePublisher: AnyPublisher<Void, Never>
  let saveTargetTimePublisher: AnyPublisher<Int, Never>
  let viewDidAppearPublisher: AnyPublisher<Void, Never>
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
  private let savePhotoUseCase: SavePhotoUseCaseRepresentable
  private let prevChallengeLoadUseCase: PrevChallengeLoadUseCaseRepresentable
  private let prevChallengeWriteUseCase: PrevChallengeWriteUseCaseRepresentable

  init(
    targetTimeUseCase: TargetTimeUseCaseRepresentable,
    savePhotoUseCase: SavePhotoUseCaseRepresentable,
    prevChallengeLoadUseCase: PrevChallengeLoadUseCaseRepresentable,
    prevChallengeWriteUseCase: PrevChallengeWriteUseCaseRepresentable
  ) {
    self.targetTimeUseCase = targetTimeUseCase
    self.savePhotoUseCase = savePhotoUseCase
    self.prevChallengeLoadUseCase = prevChallengeLoadUseCase
    self.prevChallengeWriteUseCase = prevChallengeWriteUseCase
  }
}

// MARK: MealTimerSceneViewModelRepresentable

extension MealGokHomeViewModel: MealTimerSceneViewModelRepresentable {
  public func transform(input: MealGokHomeViewModelInput) -> MealGokHomeViewModelOutput {
    subscriptions.removeAll()

    // 화면에 진입하고, 챌린지의 성공 유무에 따라 다르게 동작합니다.
    input.viewDidAppearPublisher
      .sink { [prevChallengeLoadUseCase, router] _ in
        let state = prevChallengeLoadUseCase.checkPrevChallenge()
        switch state {
          // Router를 통한 화면 이동
        case let .timer(targetMinutes, startDate):
          // 아직 챌린지 기간 이내의 시간이라면 챌린지 화면으로 돌아갑니다.
          router?.startMealTimerScene(targetMinute: targetMinutes, startTime: startDate, isLocalNotificationNeed: false)
          
          // 챌린지를 완성한 조건이라면, 채린지 완료 화면으로 Routing 합니다. 
        case let .successChallenge(targetMinutes, startDate):
          router?.startMealTimerScene(targetMinute: targetMinutes, startTime: startDate, isLocalNotificationNeed: false)
        case .idle:
          break
        }
      }
      .store(in: &subscriptions)

    input.startTimeScenePublisher
      .sink { [targetTimeUseCase, router, savePhotoUseCase, prevChallengeWriteUseCase] data in
        let startDate = savePhotoUseCase.saveDataWithNowDescription(data)
        let targetMinute = targetTimeUseCase.targetTime()
        prevChallengeWriteUseCase.setPrevChallengeStartDate(startDate)
        prevChallengeWriteUseCase.setPrevChallengeTotalSeconds(targetMinute * 60)
        router?.startMealTimerScene(targetMinute: targetMinute, startTime: startDate, isLocalNotificationNeed: true)
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
