//
//  MealTimerSceneViewController.swift
//  MealTimerFeature
//
//  Created by MaraMincho on 1/30/24.
//  Copyright © 2024 com.maramincho. All rights reserved.
//

import Combine
import CombineCocoa
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

  private lazy var timerView: TimerView = {
    let view = TimerView(contentSize: .init(width: 240, height: 240))

    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()

  private let cameraButton: UIButton = {
    var configure: UIButton.Configuration = .plain()
    let imageConfigure: UIImage.SymbolConfiguration = .init(pointSize: 35)
    configure.image = UIImage(systemName: Constants.cameraButtonTitleText, withConfiguration: imageConfigure)
    configure.titleAlignment = .leading
    configure.baseForegroundColor = DesignSystemColor.gray03
    let button = UIButton(configuration: configure)

    button.translatesAutoresizingMaskIntoConstraints = false
    return button
  }()

  private let timerDescriptionLabel: UILabel = {
    let label = UILabel()
    label.textColor = DesignSystemColor.primaryText
    label.font = .preferredFont(forTextStyle: .body)
    label.text = Constants.timerDescriptionLabelText
    label.textAlignment = .center

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

  override func viewIsAppearing(_ animated: Bool) {
    super.viewIsAppearing(animated)
    setupHierarchyAndConstraints()
  }
}

private extension MealTimerSceneViewController {
  func setup() {
    setupStyles()
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

    view.addSubview(timerView)
    timerView.topAnchor.constraint(equalTo: descriptionTitleLabel.bottomAnchor, constant: Metrics.timerTopSpacing).isActive = true
    timerView.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor).isActive = true

    view.addSubview(cameraButton)
    cameraButton.topAnchor.constraint(equalTo: timerView.topAnchor).isActive = true
    cameraButton.leadingAnchor
      .constraint(equalTo: timerView.trailingAnchor, constant: Metrics.cameraButtonAndTimerViewTrailingSpacing).isActive = true

    view.addSubview(timerDescriptionLabel)
    timerDescriptionLabel.topAnchor
      .constraint(equalTo: timerView.bottomAnchor, constant: Metrics.timerDescriptionLabelTopSpacing).isActive = true
    timerDescriptionLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor).isActive = true
    timerDescriptionLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor).isActive = true
  }

  func setupStyles() {
    view.backgroundColor = DesignSystemColor.primaryBackground
    navigationController?.isNavigationBarHidden = true
  }

  func bind() {
    subscriptions.removeAll()

    let output = viewModel.transform(input: .init(
      didCameraButtonTouchPublisher: cameraButton.publisher(event: .touchUpInside).map { _ in return }.eraseToAnyPublisher(),
      didTimerStartButtonTouchPublisher: timerView.publisher(gesture: .tap).map { _ in return }.eraseToAnyPublisher()
    ))

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

    static let timerTopSpacing: CGFloat = 137

    static let cameraButtonAndTimerViewTrailingSpacing: CGFloat = -24

    static let timerDescriptionLabelTopSpacing: CGFloat = 27
  }

  enum Constants {
    static let titleLabelText: String = "밀꼭"
    static let descriptionTitleText: String = "천천히 먹기: 가장 쉽고 빠른 다이어트"

    static let timerDescriptionText: String = "시간이 완료되면 자동으로 타이머가 울립니다"

    static let cameraButtonTitleText: String = "camera.viewfinder"

    static let timerDescriptionLabelText: String = "시간이 완료되면 자동으로 타이머가 울립니다"
  }
}
