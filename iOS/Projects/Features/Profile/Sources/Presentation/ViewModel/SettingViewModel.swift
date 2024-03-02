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
  let didTapCell: AnyPublisher<SettingTableViewProperty, Never>
}

public typealias SettingViewModelOutput = AnyPublisher<SettingState, Never>

// MARK: - SettingState

public enum SettingState {
  case idle
  case updateSettingViewProperties([SettingTableViewProperty])
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
  private let settingTableViewProperties: [SettingTableViewProperty]
  init(router: SettingViewModelRouterable? = nil, settingTableViewProperties: [SettingTableViewProperty]) {
    self.router = router
    self.settingTableViewProperties = settingTableViewProperties
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

    input
      .didTapCell
      .sink { [router] _ in
        router?.pushEditProfile()
      }
      .store(in: &subscriptions)

    let updateSnapshot: SettingViewModelOutput = Just(.updateSettingViewProperties(settingTableViewProperties)).eraseToAnyPublisher()

    let initialState: SettingViewModelOutput = Just(.idle).eraseToAnyPublisher()

    return initialState.merge(with: updateSnapshot).eraseToAnyPublisher()
  }
}
