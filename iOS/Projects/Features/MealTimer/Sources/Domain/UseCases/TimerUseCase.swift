//
//  TimerUseCase.swift
//  MealTimerFeature
//
//  Created by MaraMincho on 1/31/24.
//  Copyright © 2024 com.maramincho. All rights reserved.
//

import Combine
import Foundation
import ImageManager
import OSLog

// MARK: - TimerUseCasesRepresentable

protocol TimerUseCasesRepresentable {
  func timerLabelText() -> AnyPublisher<TimerUseCasePropertyEntity, Never>
  func start()
  func timerFinished() -> AnyPublisher<Bool, Never>
  func cancelChallenge()
}

// MARK: - TimerUseCase

final class TimerUseCase: TimerUseCasesRepresentable {
  private var oneSecondsTimer = Timer.publish(every: 1, on: .main, in: .common)

  private var startTime: Date
  private let notificationIdentifier = UUID()
  private let isFinishPublisher: CurrentValueSubject<Bool, Never> = .init(false)

  private let customStringFormatter: CustomTimeStringFormatter
  private let timerLocalNotificationUseCase: TimerLocalNotificationUseCaseRepresentable

  private let repository: SaveMealGokChalengeRepositoryRepresentable?

  init(
    startTime: Date,
    customStringFormatter: CustomTimeStringFormatter,
    timerLocalNotificationUseCase: TimerLocalNotificationUseCaseRepresentable,
    repository: SaveMealGokChalengeRepositoryRepresentable?
  ) {
    self.customStringFormatter = customStringFormatter
    self.repository = repository
    self.startTime = startTime
    self.timerLocalNotificationUseCase = timerLocalNotificationUseCase

    addCompleteNotification()
  }

  private func addCompleteNotification() {
    timerLocalNotificationUseCase.addChallengeCompleteNotification(identifier: notificationIdentifier.uuidString)
  }

  func imageDataURL() -> URL? {
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

  private func saveSuccessData() {
    do {
      try repository?.save(mealGokChallengeDTO: .init(startTime: startTime, endTime: .now, isSuccess: true, imageDataURL: imageDataURL()))
      Logger().debug("정보를 정상적으로 저장하는 것에 성공 했습니다.")
    } catch {
      // TODO: 만약 Realm의 저장이 실패할 경우 로직을 세워야 한다.
      Logger().error("error was occurred \(error.localizedDescription)")
      return
    }
  }

  func cancelChallenge() {
    do {
      try repository?.save(mealGokChallengeDTO: .init(startTime: startTime, endTime: .now, isSuccess: false, imageDataURL: imageDataURL()))
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
