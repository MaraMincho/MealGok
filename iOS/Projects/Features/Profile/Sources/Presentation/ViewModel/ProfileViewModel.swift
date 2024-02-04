//
//  ProfileViewModel.swift
//  ProfileFeature
//
//  Created by MaraMincho on 2/3/24.
//  Copyright © 2024 com.maramincho. All rights reserved.
//

import Combine
import Foundation

// MARK: - ProfileViewModelInput

public struct ProfileViewModelInput {}

public typealias ProfileViewModelOutput = AnyPublisher<ProfileState, Never>

// MARK: - ProfileState

public enum ProfileState {
  case idle
}

// MARK: - ProfileViewModelRepresentable

protocol ProfileViewModelRepresentable {
  func transform(input: ProfileViewModelInput) -> ProfileViewModelOutput
}

// MARK: - ProfileViewModel

final class ProfileViewModel {
  // MARK: - Properties

  private var subscriptions: Set<AnyCancellable> = []
}

// MARK: ProfileViewModelRepresentable

extension ProfileViewModel: ProfileViewModelRepresentable {
  public func transform(input _: ProfileViewModelInput) -> ProfileViewModelOutput {
    subscriptions.removeAll()

    let initialState: ProfileViewModelOutput = Just(.idle).eraseToAnyPublisher()

    return initialState
  }
}
