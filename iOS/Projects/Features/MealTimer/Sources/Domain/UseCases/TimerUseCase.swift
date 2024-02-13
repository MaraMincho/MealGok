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
  private let isFinishPublisher: CurrentValueSubject<Bool, Never> = .init(false)
  private lazy var imageDataURL: URL? = {
    FileCacher.isExistURL(fileName: self.startTime.description) ? FileCacher.url(fileName: self.startTime.description) : nil
  }()

  private let customStringFormatter: CustomTimeStringFormatter

  private let repository: SaveMealGokChalengeRepositoryRepresentable?

  init(startTime: Date, customStringFormatter: CustomTimeStringFormatter, repository: SaveMealGokChalengeRepositoryRepresentable?) {
    self.customStringFormatter = customStringFormatter
    self.repository = repository
    self.startTime = startTime
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
      try repository?.save(mealGokChallengeDTO: .init(startTime: startTime, endTime: .now, isSuccess: true, imageDataURL: imageDataURL))
      Logger().debug("정보를 정상적으로 저장하는 것에 성공 했습니다.")
    } catch {
      // TODO: 만약 Realm의 저장이 실패할 경우 로직을 세워야 한다.
      Logger().error("error was occurred \(error.localizedDescription)")
      return
    }
  }

  func cancelChallenge() {
    do {
      try repository?.save(mealGokChallengeDTO: .init(startTime: startTime, endTime: .now, isSuccess: false, imageDataURL: imageDataURL))
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
