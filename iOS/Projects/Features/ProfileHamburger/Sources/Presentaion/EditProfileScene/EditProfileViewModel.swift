//
//  EditProfileViewModel.swift
//  ProfileHamburgerFeature
//
//  Created by MaraMincho on 2/27/24.
//  Copyright © 2024 com.maramincho. All rights reserved.
//

import Combine
import Foundation

// MARK: - EditProfileViewModelInput

public struct EditProfileViewModelInput {}

public typealias EditProfileViewModelOutput = AnyPublisher<EditProfileState, Never>

// MARK: - EditProfileState

public enum EditProfileState {
  case idle
}

// MARK: - EditProfileViewModelRepresentable

protocol EditProfileViewModelRepresentable {
  func transform(input: EditProfileViewModelInput) -> EditProfileViewModelOutput
}

// MARK: - EditProfileViewModel

final class EditProfileViewModel {
  // MARK: - Properties

  private var subscriptions: Set<AnyCancellable> = []
}

// MARK: EditProfileViewModelRepresentable

extension EditProfileViewModel: EditProfileViewModelRepresentable {
  public func transform(input _: EditProfileViewModelInput) -> EditProfileViewModelOutput {
    subscriptions.removeAll()

    let initialState: EditProfileViewModelOutput = Just(.idle).eraseToAnyPublisher()

    return initialState
  }
}
