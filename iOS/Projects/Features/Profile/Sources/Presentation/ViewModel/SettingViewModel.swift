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

public struct SettingViewModelInput {}

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
  public func transform(input _: SettingViewModelInput) -> SettingViewModelOutput {
    subscriptions.removeAll()

    let initialState: SettingViewModelOutput = Just(.idle).eraseToAnyPublisher()

    return initialState
  }
}
