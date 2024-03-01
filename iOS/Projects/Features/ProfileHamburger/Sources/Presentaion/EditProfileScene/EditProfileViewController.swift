//
//  EditProfileViewController.swift
//  ProfileHamburgerFeature
//
//  Created by MaraMincho on 2/27/24.
//  Copyright © 2024 com.maramincho. All rights reserved.
//

import Combine
import CombineCocoa
import DesignSystem
import MealGokCacher
import PhotosUI
import UIKit

// MARK: - EditProfileViewController

final class EditProfileViewController: UIViewController {
  // MARK: Properties

  private let viewModel: EditProfileViewModelRepresentable

  private let loadProfileInformation: PassthroughSubject<Void, Never> = .init()
  private let editNickNamePublisher: PassthroughSubject<String, Never> = .init()
  private let editImagePublisher: PassthroughSubject<Data, Never> = .init()
  private let editBiographyPublisher: PassthroughSubject<String, Never> = .init()

  private var subscriptions: Set<AnyCancellable> = []

  // MARK: UI Components

  let contentScrollView: UIScrollView = {
    let scrollView = UIScrollView()

    scrollView.translatesAutoresizingMaskIntoConstraints = false
    return scrollView
  }()

  private let titleLabel: UILabel = {
    let label = UILabel()
    label.font = .preferredFont(forTextStyle: .title2, weight: .bold)
    label.textColor = DesignSystemColor.primaryText
    label.text = Constants.titleText
    label.textAlignment = .center

    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()

  private let backButton: UIButton = {
    let button = UIButton(configuration: .plain())
    var configure = button.configuration
    let imageSymbolConfiguration = UIImage.SymbolConfiguration(font: .preferredFont(forTextStyle: .title2))
    configure?.image = UIImage(systemName: Constants.backButtonIconSystemName, withConfiguration: imageSymbolConfiguration)
    configure?.baseForegroundColor = DesignSystemColor.main01
    button.configuration = configure

    button.contentHorizontalAlignment = .left
    button.translatesAutoresizingMaskIntoConstraints = false
    return button
  }()

  private let profileImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.layer.cornerRadius = Metrics.imageViewWidthAndHeight / 2
    imageView.layer.masksToBounds = false
    imageView.layer.cornerCurve = .continuous
    imageView.layer.borderColor = DesignSystemColor.main01.cgColor
    imageView.layer.borderWidth = Metrics.imageViewBorderWidth

    imageView.clipsToBounds = true

    imageView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    imageView.translatesAutoresizingMaskIntoConstraints = false
    return imageView
  }()

  private let profileEditSymbolImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.layer.cornerRadius = Metrics.editSymbolImageViewWidthAndHeight / 2
    imageView.layer.masksToBounds = false
    imageView.layer.cornerCurve = .continuous
    imageView.tintColor = DesignSystemColor.primaryBackground

    let symbolConfiguration = UIImage.SymbolConfiguration(font: .systemFont(ofSize: 2))
    let image = UIImage(systemName: Constants.editImageViewSystemName, withConfiguration: symbolConfiguration)
    imageView.image = image
    imageView.backgroundColor = DesignSystemColor.main01
    imageView.layer.masksToBounds = true

    imageView.translatesAutoresizingMaskIntoConstraints = false
    return imageView
  }()

  private let nickNameLabel: UILabel = {
    let label = UILabel()
    label.font = .preferredFont(forTextStyle: .title3, weight: .bold)
    label.textColor = DesignSystemColor.primaryText
    label.text = Constants.nickNameLabelText

    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()

  private let nickNameTextField: UITextField = {
    let tf = UITextField()
    tf.placeholder = Constants.nickNameTextFieldPlaceHolder
    tf.borderStyle = .roundedRect
    tf.textColor = DesignSystemColor.primaryText

    tf.translatesAutoresizingMaskIntoConstraints = false
    return tf
  }()

  private let nicknameWarningLabel: UILabel = {
    let label = UILabel()
    label.text = " "
    label.textColor = DesignSystemColor.primaryText
    label.textAlignment = .left
    label.font = .preferredFont(forTextStyle: .caption1)

    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()

  private let biographyLabel: UILabel = {
    let label = UILabel()
    label.font = .preferredFont(forTextStyle: .title3, weight: .bold)
    label.textColor = DesignSystemColor.primaryText
    label.text = Constants.nickNameLabelText

    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()

  private let biographyTextView: UITextField = {
    let tf = UITextField()
    tf.placeholder = Constants.nickNameTextFieldPlaceHolder
    tf.borderStyle = .roundedRect
    tf.textColor = DesignSystemColor.primaryText

    tf.translatesAutoresizingMaskIntoConstraints = false
    return tf
  }()

  private let saveButton: UIButton = {
    let button = UIButton(configuration: .filled())
    var configure = button.configuration
    configure?.attributedTitle = .init(
      Constants.saveButtonTitleText,
      attributes: .init([
        .font: UIFont.preferredFont(forTextStyle: .title3),
      ])
    )
    configure?.attributedTitle?.font = .title2
    configure?.baseBackgroundColor = DesignSystemColor.main01
    button.configuration = configure

    button.layer.cornerRadius = 8
    button.layer.cornerCurve = .continuous
    button.layer.masksToBounds = true
    button.isEnabled = false

    button.translatesAutoresizingMaskIntoConstraints = false
    return button
  }()

  func setupHierarchyAndConstraints() {
    let safeArea = view.safeAreaLayoutGuide

    view.addSubview(saveButton)
    saveButton.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: Metrics.leadingAndTrailingGuide).isActive = true
    saveButton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -Metrics.leadingAndTrailingGuide).isActive = true
    saveButton.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: Metrics.saveButtonBottomSpacing).isActive = true
    saveButton.heightAnchor.constraint(equalToConstant: Metrics.saveButtonHeight).isActive = true

    view.addSubview(contentScrollView)
    contentScrollView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor).isActive = true
    contentScrollView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor).isActive = true
    contentScrollView.topAnchor.constraint(equalTo: safeArea.topAnchor).isActive = true
    contentScrollView.bottomAnchor.constraint(equalTo: saveButton.topAnchor, constant: Metrics.contentScrollViewBottomMargin).isActive = true

    contentScrollView.addSubview(titleLabel)
    titleLabel.topAnchor.constraint(equalTo: contentScrollView.topAnchor, constant: 36).isActive = true
    titleLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor).isActive = true
    titleLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor).isActive = true

    contentScrollView.addSubview(backButton)
    backButton.leadingAnchor.constraint(equalTo: contentScrollView.leadingAnchor).isActive = true
    backButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor).isActive = true

    contentScrollView.addSubview(profileImageView)
    profileImageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Metrics.profileImageTopSpacing).isActive = true
    profileImageView.centerXAnchor.constraint(equalTo: contentScrollView.centerXAnchor).isActive = true
    profileImageView.heightAnchor.constraint(equalToConstant: Metrics.imageViewWidthAndHeight).isActive = true
    profileImageView.widthAnchor.constraint(equalToConstant: Metrics.imageViewWidthAndHeight).isActive = true

    contentScrollView.addSubview(profileEditSymbolImageView)
    profileEditSymbolImageView.trailingAnchor.constraint(equalTo: profileImageView.trailingAnchor).isActive = true
    profileEditSymbolImageView.bottomAnchor.constraint(equalTo: profileImageView.bottomAnchor).isActive = true
    profileEditSymbolImageView.heightAnchor.constraint(equalToConstant: Metrics.editSymbolImageViewWidthAndHeight).isActive = true
    profileEditSymbolImageView.widthAnchor.constraint(equalToConstant: Metrics.editSymbolImageViewWidthAndHeight).isActive = true

    contentScrollView.addSubview(nickNameLabel)
    nickNameLabel.topAnchor
      .constraint(equalTo: profileEditSymbolImageView.bottomAnchor, constant: Metrics.nickNameLabelTopSpacing).isActive = true
    nickNameLabel.leadingAnchor
      .constraint(equalTo: contentScrollView.leadingAnchor, constant: Metrics.leadingAndTrailingGuide).isActive = true
    nickNameLabel.trailingAnchor
      .constraint(equalTo: contentScrollView.trailingAnchor, constant: -Metrics.leadingAndTrailingGuide).isActive = true

    contentScrollView.addSubview(nickNameTextField)
    nickNameTextField.topAnchor.constraint(equalTo: nickNameLabel.bottomAnchor, constant: Metrics.nickNameTextFieldTopSpacing).isActive = true
    nickNameTextField.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: Metrics.leadingAndTrailingGuide).isActive = true
    nickNameTextField.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -Metrics.leadingAndTrailingGuide).isActive = true
    nickNameTextField.heightAnchor.constraint(equalToConstant: Metrics.nickNameTextFieldHeight).isActive = true

    contentScrollView.addSubview(nicknameWarningLabel)
    nicknameWarningLabel.topAnchor
      .constraint(equalTo: nickNameTextField.bottomAnchor, constant: Metrics.nicknameWarningLabelTopSpacing).isActive = true
    nicknameWarningLabel.leadingAnchor
      .constraint(equalTo: nickNameTextField.leadingAnchor).isActive = true
    nicknameWarningLabel.trailingAnchor
      .constraint(equalTo: nickNameTextField.trailingAnchor).isActive = true
  }

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

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
  }
}

private extension EditProfileViewController {
  func setup() {
    setupStyles()
    setupHierarchyAndConstraints()
    bind()
    loadProfileInformation.send()
  }

  func setupStyles() {
    view.backgroundColor = DesignSystemColor.primaryBackground
  }

  func bind() {
    subscriptions.forEach { $0.cancel() }

    let input = EditProfileViewModelInput(
      loadProfileInformation: loadProfileInformation.eraseToAnyPublisher(),
      editNickName: nickNameTextField.textPublisher(),
      editImage: editImagePublisher.eraseToAnyPublisher(),
      editBiography: editBiographyPublisher.eraseToAnyPublisher(),
      didTapSaveButton: saveButton.touchupInsidePublisher(),
      didTapProfileEditButton: profileImageView.publisher(gesture: .tap).map { _ in return }.eraseToAnyPublisher()
    )

    backButton.touchupInsidePublisher()
      .sink { [weak self] _ in
        self?.navigationController?.popViewController(animated: true)
      }
      .store(in: &subscriptions)

    let output = viewModel.transform(input: input)
    
    output
      .receive(on: DispatchQueue.main)
      .sink { [weak self] state in
        guard let self else {
          return
        }
        switch state {
        case .idle:
          break
        case let .nickName(str):
          nickNameTextField.placeholder = str
        case let .profileImage(url):
          profileImageView.setImage(url: url, downSampleProperty: .init(size: .init(width: Metrics.imageViewWidthAndHeight, height: 0)))
        case let .biography(str):
          biographyTextView.text = str
        case let .invalidNickName(warningText):
          invalidNickname(text: warningText)
        case .validNickname:
          validNickname()
        case .emptyNickname:
          emptyNickname()
        case .pushPictureChoiceTypeSheet:
          presentPictureChoiceTypeSheet()
        case let .profileImageData(data):
          profileImageView.image = UIImage(data: data)
        case let .isEnableSaveButton(bool) :
          saveButton.isEnabled = bool
        }
      }
      .store(in: &subscriptions)
  }

  func presentPictureChoiceTypeSheet() {
    let sheet = UIAlertController(
      title: Constants.actionSheetTitle,
      message: Constants.actionSheetMessage,
      preferredStyle: .actionSheet
    )
    let cameraAction = UIAlertAction(title: Constants.actionSheetCameraActionTitle, style: .default) { _ in
    }
    let photoLibraryAction = UIAlertAction(title: Constants.actionSheetPhotsLibraryTitle, style: .default) { [weak self] _ in
      self?.pushPhotoLibrary()
    }
    let cancelAction = UIAlertAction(title: Constants.actionSheetCancelActionTitle, style: .cancel)
    [cameraAction, photoLibraryAction, cancelAction].forEach { sheet.addAction($0) }

    present(sheet, animated: true)
  }

  func pushPhotoLibrary() {
    var configuration = PHPickerConfiguration(photoLibrary: .shared())
    configuration.filter = .images
    configuration.selectionLimit = 1
    let photoPickerViewController = PHPickerViewController(configuration: configuration)
    photoPickerViewController.delegate = self
    present(photoPickerViewController, animated: true)
  }

  func emptyNickname() {
    nicknameWarningLabel.text = " "
  }

  func invalidNickname(text: String) {
    nicknameWarningLabel.text = text
    nicknameWarningLabel.textColor = UIColor.red
  }

  func validNickname() {
    nicknameWarningLabel.text = " "
  }

  enum Metrics {
    static let saveButtonBottomSpacing: CGFloat = -24
    static let saveButtonHeight: CGFloat = 44

    static let contentScrollViewBottomMargin: CGFloat = 20

    static let profileImageTopSpacing: CGFloat = 30
    static let imageViewWidthAndHeight: CGFloat = 72
    static let imageViewBorderWidth: CGFloat = 2

    static let editSymbolImageViewWidthAndHeight: CGFloat = 20

    static let nickNameLabelTopSpacing: CGFloat = 30
    static let nickNameTextFieldTopSpacing: CGFloat = 9
    static let nickNameTextFieldHeight: CGFloat = 46

    static let leadingAndTrailingGuide: CGFloat = 24

    static let nicknameWarningLabelTopSpacing: CGFloat = 6
  }

  enum Constants {
    static let identifier: String = "SettingViewControllerCell"
    static let titleText: String = "프로필 수정"
    static let backButtonIconSystemName: String = "chevron.left"
    static let editImageViewSystemName: String = "pencil"

    static let nickNameLabelText: String = "닉네임"

    static let nickNameTextFieldPlaceHolder: String = "닉네임을 입력하세요"

    static let saveButtonTitleText: String = "변경사항 저장하기"

    static let actionSheetTitle = "불러오기 방식"
    static let actionSheetMessage = "사진을 불러올 방법을 선택하세요"
    static let actionSheetCameraActionTitle = "카메라로 촬영"
    static let actionSheetPhotsLibraryTitle = "앨범에서 불러오기"
    static let actionSheetCancelActionTitle = "취소"
  }
}

// MARK: PHPickerViewControllerDelegate

extension EditProfileViewController: PHPickerViewControllerDelegate {
  func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
    picker.dismiss(animated: true)
    guard let itemProvider = results.first?.itemProvider else {
      return
    }
    if itemProvider.canLoadObject(ofClass: UIImage.self) {
      itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
        guard
          error == nil,
          let profileImageData = (image as? UIImage)?.downSampleImage(downSampleProperty: .init(size: .init(width: 1024, height: 0)))
        else {
          return
        }
        self?.editImagePublisher.send(profileImageData)
      }
    }
  }
}
