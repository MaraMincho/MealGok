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

// MARK: - MealGokSuccessSceneViewController

final class MealGokSuccessSceneViewController: UIViewController {
  // MARK: Properties

  private let viewModel: MealGokSuccessSceneViewModelRepresentable

  private let mealGokContentProperty: MealGokSuccessContentViewProperty

  private var contentScrollViewContentSize: CGSize { .init(width: UIScreen.main.bounds.width, height: buttonStackView.frame.maxY + 20) }

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

  private lazy var mealGokSuccessContentView: MealGokSuccessContentView = {
    let view = MealGokSuccessContentView(frame: .zero, mealGokContentProperty: mealGokContentProperty)

    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()

  private let shareButton: UIButton = {
    let button = UIButton()
    var configure: UIButton.Configuration = .filled()
    configure.baseForegroundColor = DesignSystemColor.secondaryBackground
    configure.attributedTitle = .init(Constants.shareButtonText)
    configure.attributedTitle?.font = UIFont.preferredFont(forTextStyle: .title3, weight: .bold)
    configure.baseBackgroundColor = DesignSystemColor.main01
    configure.contentInsets = .init(top: 10, leading: 0, bottom: 10, trailing: 0)
    button.configuration = configure

    button.translatesAutoresizingMaskIntoConstraints = false
    return button
  }()

  private let goHomeButton: UIButton = {
    let button = UIButton(type: .custom)
    var configure: UIButton.Configuration = .filled()
    configure.title = Constants.mealGokTimerSceneButtonText
    configure.baseForegroundColor = DesignSystemColor.secondaryBackground
    configure.attributedTitle?.font = UIFont.preferredFont(forTextStyle: .title3, weight: .semibold)
    configure.baseBackgroundColor = DesignSystemColor.main03
    configure.contentInsets = .init(top: 10, leading: 0, bottom: 10, trailing: 0)
    button.configuration = configure

    button.translatesAutoresizingMaskIntoConstraints = false
    return button
  }()

  private lazy var buttonStackView: UIStackView = {
    let stackView = UIStackView(arrangedSubviews: [
      //shareButton, 차후에 글쓰기 기능이 생긴다면 추가 예정
      goHomeButton,
    ])
    stackView.axis = .vertical
    stackView.alignment = .fill
    stackView.distribution = .fill
    stackView.spacing = Metrics.buttonsSpacing

    stackView.translatesAutoresizingMaskIntoConstraints = false
    return stackView
  }()

  private let contentScrollView: UIScrollView = {
    let scrollView = UIScrollView()

    scrollView.translatesAutoresizingMaskIntoConstraints = false
    return scrollView
  }()

  // MARK: Initializations

  init(viewModel: MealGokSuccessSceneViewModelRepresentable, mealGokContentProperty: MealGokSuccessContentViewProperty) {
    self.viewModel = viewModel
    self.mealGokContentProperty = mealGokContentProperty
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
    contentScrollView.contentSize = contentScrollViewContentSize
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

    view.addSubview(contentScrollView)
    contentScrollView.topAnchor.constraint(equalTo: safeArea.topAnchor).isActive = true
    contentScrollView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor).isActive = true
    contentScrollView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor).isActive = true
    contentScrollView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor).isActive = true

    contentScrollView.addSubview(titleLabel)
    titleLabel.topAnchor.constraint(equalTo: contentScrollView.topAnchor, constant: Metrics.topSpacing).isActive = true
    titleLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: Metrics.leadingAndTrailingGuideValue).isActive = true
    titleLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -Metrics.leadingAndTrailingGuideValue).isActive = true

    contentScrollView.addSubview(mealGokSuccessContentView)
    mealGokSuccessContentView.topAnchor
      .constraint(equalTo: titleLabel.bottomAnchor, constant: Metrics.titleLabelAndContentSpacing).isActive = true
    mealGokSuccessContentView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor).isActive = true
    mealGokSuccessContentView.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor).isActive = true

    contentScrollView.addSubview(buttonStackView)
    buttonStackView.topAnchor
      .constraint(equalTo: mealGokSuccessContentView.bottomAnchor, constant: Metrics.contentAndButtonSpacing).isActive = true
    buttonStackView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor).isActive = true
    buttonStackView.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor).isActive = true
  }

  func setupStyles() {
    view.backgroundColor = DesignSystemColor.primaryBackground
  }

  func bind() {
    let output = viewModel.transform(input: .init(
      shareButtonDidTap: shareButton.touchupInsidePublisher(),
      goHomeButtonDidTap: goHomeButton.touchupInsidePublisher()
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
    static let topSpacing: CGFloat = 12

    static let leadingAndTrailingGuideValue: CGFloat = 24

    static let titleLabelAndContentSpacing: CGFloat = 36

    static let contentAndButtonSpacing: CGFloat = 48

    static let buttonsSpacing: CGFloat = 24
  }

  enum Constants {
    static let titleLabelText = "고생하셨습니다."

    static let shareButtonText = "공유하기"

    static let mealGokTimerSceneButtonText = "처음으로"
  }
}
