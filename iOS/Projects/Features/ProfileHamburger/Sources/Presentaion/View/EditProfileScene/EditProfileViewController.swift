// 
//  EditProfileViewController.swift
//  ProfileHamburgerFeature
//
//  Created by MaraMincho on 2/27/24.
//  Copyright © 2024 com.maramincho. All rights reserved.
//

import Combine
import DesignSystem
import UIKit

final class EditProfileViewController: UIViewController {

  // MARK: Properties

  private let viewModel: EditProfileViewModelRepresentable

  private var subscriptions: Set<AnyCancellable> = []

  // MARK: UI Components

  // MARK: Initializations

  init(viewModel: EditProfileViewModelRepresentable) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }

  @available(*, unavailable)
  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: Life Cycles

  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
  }


}

private extension EditProfileViewController {
  func setup() {
    setupStyles()
    setupHierarchyAndConstraints()
    bind()
  }
  
  func setupHierarchyAndConstraints() {
    let safeArea = view.safeAreaLayoutGuide
    
  }
  
  func setupStyles() {
    view.backgroundColor = DesignSystemColor.primaryBackground
  }
  
  func bind() {
    let output = viewModel.transform(input: .init())
    output.sink { state in
      switch state {
      case .idle:
        break
      }
    }
    .store(in: &subscriptions)
  }
  
  enum Metrics {
    
  }
}
