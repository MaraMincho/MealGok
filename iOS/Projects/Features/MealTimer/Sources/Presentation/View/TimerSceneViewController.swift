//
//  TimerSceneViewController.swift
//  MealTimerFeature
//
//  Created by MaraMincho on 1/31/24.
//  Copyright © 2024 com.maramincho. All rights reserved.
//

import Combine
import DesignSystem
import UIKit

// MARK: - TimerSceneViewController

final class TimerSceneViewController: UIViewController {
  // MARK: Properties

  private let viewDidAppearPublisher: PassthroughSubject<Void, Never> = .init()

  private let generator = UINotificationFeedbackGenerator()

  private let viewModel: TimerSceneViewModelRepresentable

  private var subscriptions: Set<AnyCancellable> = []

  // MARK: UI Components

  private let timerView = TimerView(contentSize: Metrics.timerIntrinsicContentSize)

  // MARK: Initializations

  init(viewModel: TimerSceneViewModelRepresentable) {
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

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    generator.notificationOccurred(.success)
    viewDidAppearPublisher.send()
  }
}

private extension TimerSceneViewController {
  func setup() {
    setupStyles()
    setupHierarchyAndConstraints()
    bind()
  }

  func setupHierarchyAndConstraints() {
    view.addSubview(timerView)
    timerView.translatesAutoresizingMaskIntoConstraints = false
    timerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    timerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
  }

  func setupStyles() {
    view.backgroundColor = DesignSystemColor.primaryText
  }

  func bind() {
    let output = viewModel.transform(input: .init(
      viewDidAppear: viewDidAppearPublisher.eraseToAnyPublisher()
    ))
    output.sink { [weak self] state in
      switch state {
      case let .updateTimerView(property):
        self?.timerView.updateTimerLabel(minutes: property.minute, seconds: property.seconds)
        self?.timerView.updateFan(to: property.fanRadian)
      case .idle:
        break
      }
    }
    .store(in: &subscriptions)
  }

  enum Metrics {
    static let timerIntrinsicContentSize: CGSize = .init(width: 290, height: 290)
  }
}
