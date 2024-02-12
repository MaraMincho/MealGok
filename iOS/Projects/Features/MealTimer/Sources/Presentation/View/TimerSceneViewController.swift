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

  private let cancelButtonDidTapPublisher: PassthroughSubject<Void, Never> = .init()

  private var isPresentingAlert: Bool = false

  // MARK: UI Components

  private let timerView = TimerView(contentSize: Metrics.timerIntrinsicContentSize)

  private let descriptionLabel: UILabel = {
    let label = UILabel()
    label.text = Constants.descriptionText
    label.font = .preferredFont(forTextStyle: .caption1, weight: .medium)
    label.textColor = DesignSystemColor.secondaryBackground

    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()

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

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    NotificationCenter.default.post(name: Notification.Name(rawValue: "AllScreenMode"), object: nil)
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    NotificationCenter.default.post(name: Notification.Name(rawValue: "PortraitScreenMode"), object: nil)
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

    view.addSubview(descriptionLabel)
    descriptionLabel.topAnchor.constraint(equalTo: timerView.bottomAnchor, constant: Metrics.descriptionLabelSpacing).isActive = true
    descriptionLabel.centerXAnchor.constraint(equalTo: timerView.centerXAnchor).isActive = true
  }

  func setupStyles() {
    view.backgroundColor = DesignSystemColor.primaryText
  }

  func bind() {
    let output = viewModel.transform(input: .init(
      viewDidAppear: viewDidAppearPublisher.eraseToAnyPublisher(),
      didTapCompleteButton: timerView.publisher(gesture: .tap).eraseToAnyPublisher().map { _ in return }.eraseToAnyPublisher(),
      showAlertPublisher: timerView.publisher(gesture: .longPress).eraseToAnyPublisher().map { _ in return }.eraseToAnyPublisher(),
      didCancelChallenge: cancelButtonDidTapPublisher.eraseToAnyPublisher()
    ))

    output.sink { [weak self] state in
      switch state {
      case let .updateTimerView(property):
        self?.timerView.updateTimerLabel(minutes: property.minute, seconds: property.seconds)
        self?.timerView.updateFan(to: property.fanRadian)
      case .timerDidFinish:
        self?.dismiss(animated: false)
        self?.timerView.didFinish()
      case .showFinishConfirmAlert:
        self?.showFinishAlert()
      case .idle:
        break
      }
    }
    .store(in: &subscriptions)
  }

  func showFinishAlert() {
    guard isPresentingAlert == false else {
      return
    }

    generator.notificationOccurred(.warning)

    isPresentingAlert.toggle()
    let alert = UIAlertController(title: Constants.alertTitle, message: Constants.alertMessage, preferredStyle: .alert)

    let cancelButton = UIAlertAction(title: Constants.cancelButtonTitle, style: .cancel) { [weak self] _ in
      self?.isPresentingAlert.toggle()
    }
    let confirmButton = UIAlertAction(title: Constants.confirmButtonTitle, style: .destructive) { [weak self] _ in
      self?.cancelButtonDidTapPublisher.send()
    }

    alert.addAction(cancelButton)
    alert.addAction(confirmButton)

    present(alert, animated: true)
  }

  enum Metrics {
    static let timerIntrinsicContentSize: CGSize = .init(width: 290, height: 290)

    static let descriptionLabelSpacing: CGFloat = 20
  }

  enum Constants {
    static let descriptionText: String = "타이머를 3초이상 누르면 도전을 종료할 수 있습니다."

    static let alertTitle: String = "경고"
    static let alertMessage: String = "도전을 정말로 취소 하시겠습니까?"
    static let cancelButtonTitle: String = "취소"
    static let confirmButtonTitle: String = "도전 끝내기"
  }
}
