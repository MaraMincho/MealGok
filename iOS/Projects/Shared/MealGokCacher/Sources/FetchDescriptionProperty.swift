//
//  FetchDescriptionProperty.swift
//  ImageManager
//
//  Created by MaraMincho on 2/18/24.
//  Copyright © 2024 com.maramincho. All rights reserved.
//

import Combine
import Foundation

// MARK: - FetchDescription

protocol FetchDescription {
  var fetchStatus: CurrentValueSubject<FetchDescriptionStatus, Never> { get set }

  /// 현재 fetchStatus를 리턴합니다.
  func currentFetchStatus() -> FetchDescriptionStatus

  /// fetchStatusPublisher를 리턴합니다.
  func fetchStatusPublisher() -> AnyPublisher<FetchDescriptionStatus, Never>

  func cancelFetch()
}

// MARK: - FetchDescriptionCancellable

public final class FetchDescriptionCancellable: FetchDescription {
  var fetchStatus: CurrentValueSubject<FetchDescriptionStatus, Never>
  private weak var fetchSubscription: AnyCancellable?

  init(fetchStatus: CurrentValueSubject<FetchDescriptionStatus, Never>, fetchSubscription: AnyCancellable?) {
    self.fetchStatus = fetchStatus
    self.fetchSubscription = fetchSubscription
  }

  /// 현재 fetchStatus를 리턴합니다.
  func currentFetchStatus() -> FetchDescriptionStatus {
    return fetchStatus.value
  }

  /// fetchStatusPublisher를 리턴합니다.
  func fetchStatusPublisher() -> AnyPublisher<FetchDescriptionStatus, Never> {
    return fetchStatus.eraseToAnyPublisher()
  }

  func cancelFetch() {
    fetchSubscription?.cancel()
  }
}

// MARK: - FetchDescriptionTask

public final class FetchDescriptionTask: FetchDescription {
  var fetchStatus: CurrentValueSubject<FetchDescriptionStatus, Never>
  var taskHandle: Task<Data, Error>?

  init(fetchStatus: CurrentValueSubject<FetchDescriptionStatus, Never>, taskHandle: Task<Data, Error>?) {
    self.fetchStatus = fetchStatus
    self.taskHandle = taskHandle
  }

  func currentFetchStatus() -> FetchDescriptionStatus {
    return fetchStatus.value
  }

  func fetchStatusPublisher() -> AnyPublisher<FetchDescriptionStatus, Never> {
    return fetchStatus.eraseToAnyPublisher()
  }

  func cancelFetch() {
    taskHandle?.cancel()
  }
}

// MARK: - FetchDescriptionStatus

public enum FetchDescriptionStatus {
  /// 아직 Fetch를 시작하지 않았습니다.
  ///
  /// URL을 Fetch하라는 명령이 있었는지 확인해 보세요
  case notStarted

  /// 현재 Fetch중입니다.
  case fetching

  /// Fetch가 끝났습니다.
  case finished

  /// Fetch중 에러가 발생했습니다.
  case error(Error)
}
