//
//  MealGokHomeViewController.swift
//  MealTimerFeature
//
//  Created by MaraMincho on 1/30/24.
//  Copyright © 2024 com.maramincho. All rights reserved.
//

import AVFoundation
import Combine
import CombineCocoa
import DesignSystem
import UIKit

// MARK: - MealGokHomeViewController

final class MealGokHomeViewController: UIViewController {
  // MARK: Properties

  private let viewModel: MealTimerSceneViewModelRepresentable

  private var subscriptions: Set<AnyCancellable> = []

  private let generator = UINotificationFeedbackGenerator()

  private let softFeedBackGenerator = UIImpactFeedbackGenerator(style: .soft)

  private var contentScrollViewContentSize: CGSize { .init(width: UIScreen.main.bounds.width, height: targetTimeButton.frame.maxY + 20) }

  private let needUpdateTargetTimeSubject: PassthroughSubject<Void, Never> = .init()
  private let saveTargetTimeSubject: PassthroughSubject<Int, Never> = .init()
  private let startTimerSubject: PassthroughSubject<Data?, Never> = .init()
  private let viewDidAppearPublisher: PassthroughSubject<Void, Never> = .init()
  @Published private var targetTime: Int = 20

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
    view.layer.shadowColor = UIColor.black.cgColor
    view.layer.shadowOffset = .init(width: -2, height: 2)
    view.layer.shadowRadius = 3.0
    view.layer.shadowOpacity = 0.4

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
    label.font = .preferredFont(forTextStyle: .caption1, weight: .regular)
    label.text = Constants.timerDescriptionLabelText
    label.textAlignment = .center

    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()

  private let targetTimeButtonTitleLabel: UILabel = {
    let label = UILabel()
    label.font = .preferredFont(forTextStyle: .title2)
    label.textColor = DesignSystemColor.primaryText
    label.text = Constants.targetTimeButtonTitleText
    label.textAlignment = .left

    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()

  private let targetTimeButtonTimeLabel: UILabel = {
    let label = UILabel()
    label.font = .preferredFont(forTextStyle: .body, weight: .bold)
    label.textColor = DesignSystemColor.primaryText
    label.text = "20:00"
    label.textAlignment = .center

    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()

  private let targetTimeButtonBottomArrowLabel: UILabel = {
    let label = UILabel()
    label.font = .preferredFont(forTextStyle: .title2)
    label.textColor = DesignSystemColor.primaryText
    label.textAlignment = .right
    label.setText("", prependedBySymbolNamed: Constants.targetTimeButtonBottomArrowButtonImageSystemName)

    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()

  private lazy var targetTimeButtonContentStackView: UIStackView = {
    let stackView = UIStackView(arrangedSubviews: [
      targetTimeButtonTitleLabel,
      targetTimeButtonTimeLabel,
      targetTimeButtonBottomArrowLabel,
    ])

    stackView.axis = .horizontal
    stackView.distribution = .fillEqually
    stackView.alignment = .center

    stackView.isLayoutMarginsRelativeArrangement = true
    stackView.layoutMargins = .init(
      top: 0,
      left: Metrics.timerContentStackViewLeftAndRightMargin,
      bottom: 0,
      right: Metrics.timerContentStackViewLeftAndRightMargin
    )
    stackView.isUserInteractionEnabled = false

    stackView.translatesAutoresizingMaskIntoConstraints = false
    return stackView
  }()

  private lazy var targetTimeButton: UIButton = {
    let button = UIButton()
    var configure = UIButton.Configuration.filled()
    configure.baseBackgroundColor = DesignSystemColor.main03
    button.configuration = configure

    button.addSubview(targetTimeButtonContentStackView)

    button.layer.shadowColor = UIColor.black.withAlphaComponent(0.25).cgColor
    button.layer.shadowOffset = .init(width: -2, height: 2)
    button.layer.shadowOpacity = 1
    button.layer.shadowRadius = 3.0

    button.translatesAutoresizingMaskIntoConstraints = false
    return button
  }()

  private let contentScrollView: UIScrollView = {
    let scrollView = UIScrollView()

    scrollView.translatesAutoresizingMaskIntoConstraints = false
    return scrollView
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

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    contentScrollView.contentSize = contentScrollViewContentSize
    viewDidAppearPublisher.send()
  }
}

private extension MealGokHomeViewController {
  func setup() {
    setupStyles()
    bind()
    setupHierarchyAndConstraints()
    timerView.updateTimerCenterDescription(text: Constants.timerCenterDescriptionText)

    needUpdateTargetTimeSubject.send()
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
    titleLabel.leadingAnchor.constraint(equalTo: contentScrollView.leadingAnchor, constant: Metrics.leadingAndTrailingGuide).isActive = true

    contentScrollView.addSubview(descriptionTitleLabel)
    descriptionTitleLabel.topAnchor
      .constraint(equalTo: titleLabel.bottomAnchor, constant: Metrics.descriptionTitleLabelTopSpacing).isActive = true
    descriptionTitleLabel.leadingAnchor
      .constraint(equalTo: safeArea.leadingAnchor, constant: Metrics.leadingAndTrailingGuide).isActive = true

    contentScrollView.addSubview(timerView)
    timerView.topAnchor.constraint(equalTo: descriptionTitleLabel.bottomAnchor, constant: Metrics.timerTopSpacing).isActive = true
    timerView.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor).isActive = true

    contentScrollView.addSubview(cameraButton)
    cameraButton.topAnchor.constraint(equalTo: timerView.topAnchor).isActive = true
    cameraButton.leadingAnchor
      .constraint(equalTo: timerView.trailingAnchor, constant: Metrics.cameraButtonAndTimerViewTrailingSpacing).isActive = true

    contentScrollView.addSubview(timerDescriptionLabel)
    timerDescriptionLabel.topAnchor
      .constraint(equalTo: timerView.bottomAnchor, constant: Metrics.timerDescriptionLabelTopSpacing).isActive = true
    timerDescriptionLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor).isActive = true
    timerDescriptionLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor).isActive = true

    contentScrollView.addSubview(targetTimeButton)
    targetTimeButton.topAnchor
      .constraint(equalTo: timerDescriptionLabel.bottomAnchor, constant: Metrics.targetTimerButtonTopSpacing).isActive = true
    targetTimeButton.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: Metrics.leadingAndTrailingGuide).isActive = true
    targetTimeButton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -Metrics.leadingAndTrailingGuide).isActive = true
    targetTimeButton.heightAnchor.constraint(equalToConstant: Metrics.buttonHeight).isActive = true

    targetTimeButtonContentStackView.leadingAnchor.constraint(equalTo: targetTimeButton.leadingAnchor).isActive = true
    targetTimeButtonContentStackView.trailingAnchor.constraint(equalTo: targetTimeButton.trailingAnchor).isActive = true
    targetTimeButtonContentStackView.centerYAnchor.constraint(equalTo: targetTimeButton.centerYAnchor).isActive = true
  }

  func setupStyles() {
    view.backgroundColor = DesignSystemColor.primaryBackground
    navigationController?.isNavigationBarHidden = true
  }

  func bind() {
    subscriptions.removeAll()

    targetTimeButton.publisher(event: .touchUpInside)
      .sink { [weak self] _ in
        guard let self else { return }
        presentAlertAction()
      }
      .store(in: &subscriptions)

    let output = viewModel.transform(input: .init(
      didCameraButtonTouchPublisher: cameraButton.publisher(event: .touchUpInside).map { _ in return }.eraseToAnyPublisher(),
      startTimeScenePublisher: startTimerSubject.eraseToAnyPublisher(),
      needUpdateTargetTimePublisher: needUpdateTargetTimeSubject.eraseToAnyPublisher(),
      saveTargetTimePublisher: saveTargetTimeSubject.eraseToAnyPublisher(),
      viewDidAppearPublisher: viewDidAppearPublisher.eraseToAnyPublisher()
    ))

    $targetTime.sink { [weak self] targetTime in
      self?.updateTargetTime(targetTime)
    }
    .store(in: &subscriptions)

    output.sink { [weak self] state in
      switch state {
      case .presentCamera:
        self?.generator.notificationOccurred(.success)
        self?.presentCameraPicker()
      case let .targetTime(value):
        self?.targetTime = value
        self?.updateTargetTime(value)
      case .idle:
        break
      }
    }
    .store(in: &subscriptions)

    bindTimerViewGesture()
  }

  func bindTimerViewGesture() {
    timerView.publisher(gesture: .tap)
      .sink { [weak self] _ in
        self?.startTimerSubject.send(nil)
      }
      .store(in: &subscriptions)
  }

  func presentAlertAction() {
    let alert = UIAlertController(title: "목표 시간", message: "목표하는 시간을 스와이프 해주세요", preferredStyle: .actionSheet)
    let curVal = CurrentValueSubject<Int, Never>(10)
    let slider = UISlider()
    slider.layoutMargins = .init(top: 10, left: 10, bottom: 10, right: 10)
    slider.maximumValue = 20
    slider.minimumValue = 10
    slider.heightAnchor.constraint(equalToConstant: 120).isActive = true
    slider.value = Float(targetTime)
    slider.publisher(event: .valueChanged)
      .compactMap { ($0 as? UISlider)?.value }
      .sink { value in
        let roundValue = round(value)
        let currentVal = Int(roundValue)

        if curVal.value != currentVal {
          curVal.send(currentVal)
        }
        slider.value = roundValue
        alert.title = "목표 시간: \(Int(roundValue))분"
      }
      .store(in: &subscriptions)

    curVal.sink { [weak self] _ in
      self?.softFeedBackGenerator.impactOccurred()
    }.store(in: &subscriptions)

    let confirmButton = UIAlertAction(title: "선택 완료", style: .cancel) { [weak self] _ in
      let targetTimeValue = Int(slider.value)
      self?.updateTargetTime(Int(slider.value))
      self?.saveTargetTimeSubject.send(targetTimeValue)
    }

    let sliderViewController = UIViewController()
    sliderViewController.view = slider

    alert.addAction(confirmButton)
    alert.setValue(sliderViewController, forKey: "ContentViewController")

    present(alert, animated: true)
  }

  func presentCameraPicker() {
    let pickerController = UIImagePickerController()
    pickerController.delegate = self
    pickerController.mediaTypes = ["public.image"]
    pickerController.sourceType = .camera
    present(pickerController, animated: true)
  }

  func updateTargetTime(_ targetTime: Int) {
    targetTimeButtonTimeLabel.text = "\(targetTime.description):00"
  }

  enum Metrics {
    static let topSpacing: CGFloat = 36
    static let leadingAndTrailingGuide: CGFloat = 24

    static let descriptionTitleLabelTopSpacing: CGFloat = 13

    static let timerTopSpacing: CGFloat = 137

    static let cameraButtonAndTimerViewTrailingSpacing: CGFloat = -24

    static let targetTimerButtonTopSpacing: CGFloat = 48

    static let timerDescriptionLabelTopSpacing: CGFloat = 27

    static let timerContentStackViewLeftAndRightMargin: CGFloat = 24

    static let buttonHeight: CGFloat = 52
  }

  enum Constants {
    static let titleLabelText: String = "밀꼭"
    static let descriptionTitleText: String = "천천히 먹기: 가장 쉽고 빠른 다이어트"

    static let timerCenterDescriptionText: String = "탭 하여\n타이머 시작"

    static let timerDescriptionText: String = "시간이 완료되면 자동으로 타이머가 울립니다"

    static let cameraButtonTitleText: String = "camera.viewfinder"

    static let timerDescriptionLabelText: String = "시간이 완료되면 자동으로 타이머가 울립니다"

    static let targetTimeButtonTitleText: String = "목표 시간"
    static let targetTimeButtonBottomArrowButtonImageSystemName: String = "chevron.down"
  }
}

// MARK: UINavigationControllerDelegate, UIImagePickerControllerDelegate

extension MealGokHomeViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
  func imagePickerController(
    _ picker: UIImagePickerController,
    didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
  ) {
    guard
      let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage,
      let data = image.pngData()
    else {
      picker.dismiss(animated: true)
      return
    }
    startTimerSubject.send(data)
    picker.dismiss(animated: true, completion: nil)
  }
}

private extension UILabel {
  func setText(_ text: String, prependedBySymbolNamed symbolSystemName: String, font: UIFont? = nil) {
    if #available(iOS 13.0, *) {
      if let font { self.font = font }
      let symbolConfiguration = UIImage.SymbolConfiguration(font: self.font)
      let symbolImage = UIImage(systemName: symbolSystemName, withConfiguration: symbolConfiguration)?.withRenderingMode(.alwaysTemplate)
      let symbolTextAttachment = NSTextAttachment()
      symbolTextAttachment.image = symbolImage
      let attributedText = NSMutableAttributedString()
      attributedText.append(NSAttributedString(attachment: symbolTextAttachment))
      attributedText.append(NSAttributedString(string: " " + text))
      self.attributedText = attributedText
    } else {
      self.text = text // fallback
    }
  }
}
