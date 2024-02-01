// 
//  MealGokSuccessSceneViewController.swift
//  MealTimerFeature
//
//  Created by MaraMincho on 2/1/24.
//  Copyright © 2024 com.maramincho. All rights reserved.
//

import Combine
import DesignSystem
import UIKit

final class MealGokSuccessSceneViewController: UIViewController {

  // MARK: Properties

  private let viewModel: MealGokSuccessSceneViewModelRepresentable

  private var subscriptions: Set<AnyCancellable> = []

  // MARK: UI Components

  private let titleLabel: UILabel = {
    let label = UILabel()
    label.textColor = DesignSystemColor.primaryText
    label.font = .boldSystemFont(ofSize: 34)
    label.text = Constants.titleLabelText
    
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  
  // MARK: Initializations

  init(viewModel: MealGokSuccessSceneViewModelRepresentable) {
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

private extension MealGokSuccessSceneViewController {
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
  
  enum Constants {
    static let titleLabelText = "고생하셨습니다."
  }
}
