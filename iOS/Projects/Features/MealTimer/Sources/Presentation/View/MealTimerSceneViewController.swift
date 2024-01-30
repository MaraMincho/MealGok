//
//  MealTimerSceneViewController.swift
//  MealTimerFeature
//
//  Created by MaraMincho on 1/30/24.
//  Copyright © 2024 com.maramincho. All rights reserved.
//

import Combine
import DesignSystem
import UIKit

// MARK: - MealTimerSceneViewController

final class MealTimerSceneViewController: UIViewController {
  // MARK: Properties

  private let viewModel: MealTimerSceneViewModelRepresentable

  private var subscriptions: Set<AnyCancellable> = []

  // MARK: UI Components

  private let titleLabel: UILabel = {
    let label = UILabel()
    label.textColor = DesignSystemColor.main01
    label.font = .preferredFont(forTextStyle: .title1, weight: .bold)
    label.text = Constants.titleLabelText
    label.accessibilityLabel = label.text
    label.backgroundColor = .black

    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()

  private let descriptionTitleLabel: UILabel = {
    let label = UILabel()
    label.textColor = DesignSystemColor.primaryText
    label.font = .preferredFont(forTextStyle: .title3, weight: .medium)
    label.text = Constants.descriptionTitleText
    label.accessibilityLabel = label.text

    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()

  // MARK: Initializations

  init(viewModel: MealTimerSceneViewModelRepresentable) {
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

private extension MealTimerSceneViewController {
  func setup() {
    setupStyles()
    setupHierarchyAndConstraints()
    bind()
  }

  func setupHierarchyAndConstraints() {
    let safeArea = view.safeAreaLayoutGuide
    view.addSubview(titleLabel)
    titleLabel.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: Metrics.topSpacing).isActive = true
    titleLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: Metrics.leadingAndTrailingGuide).isActive = true

    view.addSubview(descriptionTitleLabel)
    descriptionTitleLabel.topAnchor
      .constraint(equalTo: titleLabel.bottomAnchor, constant: Metrics.descriptionTitleLabelTopSpacing).isActive = true
    descriptionTitleLabel.leadingAnchor
      .constraint(equalTo: safeArea.leadingAnchor, constant: Metrics.leadingAndTrailingGuide).isActive = true
  }

  func setupStyles() {
    view.backgroundColor = DesignSystemColor.primaryBackground
    navigationController?.isNavigationBarHidden = true
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
    static let topSpacing: CGFloat = 0
    static let leadingAndTrailingGuide: CGFloat = 24

    static let descriptionTitleLabelTopSpacing: CGFloat = 13
  }

  enum Constants {
    static let titleLabelText: String = "밀꼭"
    static let descriptionTitleText: String = "천천히 먹기: 가장 쉽고 빠른 다이어트"

    static let timerDescriptionText: String = "시간이 완료되면 자동으로 타이머가 울립니다"
  }
}
