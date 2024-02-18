//
//  ImageFetchDescriptionProperty.swift
//  ImageManager
//
//  Created by MaraMincho on 2/18/24.
//  Copyright © 2024 com.maramincho. All rights reserved.
//

import Combine
import Foundation

// MARK: - FetchDescriptionProperty

public final class FetchDescriptionProperty {
  private var fetchStatus: CurrentValueSubject<FetchDescriptionStatus, Never>
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
