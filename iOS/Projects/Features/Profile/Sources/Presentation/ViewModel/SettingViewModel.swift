//
//  SettingViewModel.swift
//  ProfileFeature
//
//  Created by MaraMincho on 2/22/24.
//  Copyright © 2024 com.maramincho. All rights reserved.
//

import Combine
import Foundation
import RouterFactory

// MARK: - SettingViewModelInput

public struct SettingViewModelInput {
  let backButtonDidTap: AnyPublisher<Void, Never>
}

public typealias SettingViewModelOutput = AnyPublisher<SettingState, Never>

// MARK: - SettingState

public enum SettingState {
  case idle
}

// MARK: - SettingViewModelRepresentable

protocol SettingViewModelRepresentable {
  func transform(input: SettingViewModelInput) -> SettingViewModelOutput
}

// MARK: - SettingViewModel

final class SettingViewModel {
  // MARK: - Properties

  private var subscriptions: Set<AnyCancellable> = []
  private weak var router: SettingViewModelRouterable?
  init(router: SettingViewModelRouterable? = nil) {
    self.router = router
  }
}

// MARK: SettingViewModelRepresentable

extension SettingViewModel: SettingViewModelRepresentable {
  public func transform(input: SettingViewModelInput) -> SettingViewModelOutput {
    subscriptions.removeAll()

    input
      .backButtonDidTap
      .sink { [router] _ in
        router?.goBack()
      }
      .store(in: &subscriptions)

    let initialState: SettingViewModelOutput = Just(.idle).eraseToAnyPublisher()

    return initialState
  }
}
