//
//  TimerUseCase.swift
//  MealTimerFeature
//
//  Created by MaraMincho on 1/31/24.
//  Copyright © 2024 com.maramincho. All rights reserved.
//

import Combine
import Foundation
import MealGokCacher
import OSLog

// MARK: - TimerUseCasesRepresentable

protocol TimerUseCasesRepresentable {
  /// 현재 시간과 목표 시간에 관계한 TimerLabelText를 기진 TimerUseCasePropertyEntity 를 전달합니다.
  func timerLabelText() -> AnyPublisher<TimerUseCasePropertyEntity, Never>

  /// 타이머를 시작합니다.
  func start()

  /// 타이머가 종료되었는지 나타내는 Publisher를 리턴합니다.
  func timerFinished() -> AnyPublisher<Bool, Never>

  /// 하던 도전을 멈추고 강저제적으로 타이머를 종료합니다.
  func cancelChallenge()
}

// MARK: - TimerUseCase

final class TimerUseCase: TimerUseCasesRepresentable {
  private var oneSecondsTimer = Timer.publish(every: 1, on: .main, in: .common)

  private var startTime: Date
  private let notificationIdentifier = "MealGokChallengeLocalNotificationIdentifier"
  private let isFinishPublisher: CurrentValueSubject<Bool, Never> = .init(false)

  private let customStringFormatter: CustomTimeStringFormatter
  private let timerLocalNotificationUseCase: TimerLocalNotificationUseCaseRepresentable?

  private let prevChallengeDeleteRepository: PrevChallengeDeletable?
  private let saveCurrentChallengeRepository: SaveMealGokChallengeRepositoryRepresentable?

  init(
    startTime: Date,
    customStringFormatter: CustomTimeStringFormatter,
    timerLocalNotificationUseCase: TimerLocalNotificationUseCaseRepresentable?,
    saveCurrentChallengeRepository: SaveMealGokChallengeRepositoryRepresentable?,
    prevChallengeDeleteRepository: PrevChallengeDeletable
  ) {
    self.customStringFormatter = customStringFormatter
    self.saveCurrentChallengeRepository = saveCurrentChallengeRepository
    self.startTime = startTime
    self.timerLocalNotificationUseCase = timerLocalNotificationUseCase
    self.prevChallengeDeleteRepository = prevChallengeDeleteRepository

    addCompleteNotification()
  }

  func timerLabelText() -> AnyPublisher<TimerUseCasePropertyEntity, Never> {
    let initValuePublisher = Just(customStringFormatter.start()).eraseToAnyPublisher()

    let secondsPublisher = oneSecondsTimer.autoconnect()
      .compactMap { [weak self] val -> TimerUseCasePropertyEntity? in
        guard
          let self,
          isFinishPublisher.value == false
        else {
          return nil
        }
        let from = val.timeIntervalSince(startTime)

        let entity = customStringFormatter.subtract(from: from)
        if entity == nil {
          isFinishPublisher.send(true)
          saveSuccessData()
        }
        return entity
      }.eraseToAnyPublisher()

    return initValuePublisher.merge(with: secondsPublisher).eraseToAnyPublisher()
  }

  func cancelChallenge() {
    do {
      prevChallengeDeleteRepository?.deletePrevChallenge()
      timerLocalNotificationUseCase?.removeChallengeCompleteNotification(identifier: notificationIdentifier)
      try saveCurrentChallengeRepository?.save(
        mealGokChallengeDTO: .init(
          startTime: startTime,
          endTime: .now,
          isSuccess: false,
          imageDataURL: imageDataURL()
        ))
      Logger().debug("정보를 정상적으로 저장하는 것에 성공 했습니다.")
    } catch {
      // TODO: 만약 Realm의 저장이 실패할 경우 로직을 세워야 한다.
      Logger().error("error was occurred \(error.localizedDescription)")
      return
    }
  }

  func start() {
    startTime = Date.now
  }

  func timerFinished() -> AnyPublisher<Bool, Never> {
    isFinishPublisher.eraseToAnyPublisher()
  }
}

private extension TimerUseCase {
  private func addCompleteNotification() {
    timerLocalNotificationUseCase?.removeChallengeCompleteNotification(identifier: notificationIdentifier)
    timerLocalNotificationUseCase?.addChallengeCompleteNotification(identifier: notificationIdentifier)
  }

  private func imageDataURL() -> URL? {
    let dateFormatter: DateFormatter = {
      let dateFormatter = DateFormatter()
      dateFormatter.dateFormat = "yyyy-MM-dd_HH:mm"

      return dateFormatter
    }()

    let fileName = dateFormatter.string(from: startTime)
    if MealGokCacher.isExistURL(fileName: fileName) {
      return MealGokCacher.url(fileName: fileName)
    }
    return nil
  }

  private func saveSuccessData() {
    do {
      try saveCurrentChallengeRepository?
        .save(mealGokChallengeDTO: .init(startTime: startTime, endTime: .now, isSuccess: true, imageDataURL: imageDataURL()))
      Logger().debug("정보를 정상적으로 저장하는 것에 성공 했습니다.")
    } catch {
      // TODO: 만약 Realm의 저장이 실패할 경우 로직을 세워야 한다.
      Logger().error("error was occurred \(error.localizedDescription)")
      return
    }
  }
}
