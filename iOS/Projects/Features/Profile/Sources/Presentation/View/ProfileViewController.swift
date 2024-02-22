//
//  ProfileViewController.swift
//  ProfileFeature
//
//  Created by MaraMincho on 2/3/24.
//  Copyright © 2024 com.maramincho. All rights reserved.
//

import Combine
import DesignSystem
import MealGokCacher
import UIKit

// MARK: - ProfileViewControllerProperty

/// 선택 가능한 날짜를 보여주는 기능을 합니다.
struct ProfileViewControllerProperty {
  let startDate: Date
  let endDate: Date
}

// MARK: - ProfileViewController

final class ProfileViewController: UIViewController {
  // MARK: Properties

  private let profileViewControllerProperty: ProfileViewControllerProperty

  private let viewModel: ProfileViewModelRepresentable

  private var subscriptions: Set<AnyCancellable> = []

  private let didChangeDate: PassthroughSubject<DateComponents, Never> = .init()
  private let requestMealGokHistory: PassthroughSubject<Void, Never> = .init()
  let requestHistoryContentViewController: PassthroughSubject<MealGokChallengeProperty, Never> = .init()
  private let updateProfileSubject: PassthroughSubject<Void, Never> = .init()

  var decorations = Set<Date?>()

  var dataSource: ProfileViewMealGokDataSource?

  // MARK: UI Components

  private let settingButton: UIButton = {
    let button = UIButton()
    var configure = UIButton.Configuration.plain()
    let image = UIImage(systemName: Constants.settingButtonImage, withConfiguration: Constants.settingButtonImageFont)
    configure.image = .init(systemName: Constants.settingButtonImage)
    configure.baseForegroundColor = DesignSystemColor.main01
    button.configuration = configure

    button.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    button.translatesAutoresizingMaskIntoConstraints = false
    return button
  }()

  private let spacer: UILabel = {
    let label = UILabel()
    label.text = " "

    label.setContentHuggingPriority(.defaultLow, for: .horizontal)
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()

  private lazy var settingButtonWithSpacer: UIStackView = {
    let stackView = UIStackView(arrangedSubviews: [
      spacer,
      settingButton,
    ])
    stackView.axis = .horizontal
    stackView.distribution = .fill

    stackView.translatesAutoresizingMaskIntoConstraints = false
    return stackView
  }()

  private let headerStackView: ProfileContentHeaderView = {
    let view = ProfileContentHeaderView(frame: .zero)

    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()

  lazy var calendarView: UICalendarView = {
    let calendarView = UICalendarView()

    // Create an instance of the Gregorian calendar.
    let gregorianCalendar = Calendar(identifier: .gregorian)
    // Set the calendar displayed by the view.
    calendarView.calendar = gregorianCalendar
    calendarView.locale = Locale(identifier: Constants.localIdentifier)
    calendarView.fontDesign = .default
    calendarView.delegate = self
    calendarView.tintColor = DesignSystemColor.main01
    calendarView.availableDateRange = .init(start: profileViewControllerProperty.startDate, end: profileViewControllerProperty.endDate)
    calendarView.wantsDateDecorations = true
    calendarView.selectionBehavior = calendarBehavior
    calendarView.backgroundColor = DesignSystemColor.secondaryBackground

    let margin = Metrics.calendarMargin
    calendarView.layoutMargins = .init(top: margin, left: margin, bottom: margin, right: margin)

    // addCornerRadius
    calendarView.clipsToBounds = true
    calendarView.layer.cornerRadius = Metrics.headerCornerRadius
    calendarView.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMinXMinYCorner, .layerMaxXMinYCorner)

    calendarView.translatesAutoresizingMaskIntoConstraints = false
    return calendarView
  }()

  lazy var calendarBehavior: UICalendarSelectionSingleDate = {
    let behavior = UICalendarSelectionSingleDate(delegate: self)
    return behavior
  }()

  private lazy var mealGokChallengeTableView: UITableView = {
    let tableView = UITableView(frame: .zero, style: .plain)
    tableView.dataSource = dataSource
    tableView.delegate = self
    tableView.backgroundColor = DesignSystemColor.secondaryBackground
    tableView.register(ProfileViewMealGokTableViewCell.self, forCellReuseIdentifier: ProfileViewMealGokTableViewCell.identifier)
    // addCornerRadius
    tableView.clipsToBounds = true
    tableView.layer.cornerRadius = Metrics.headerCornerRadius
    tableView.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMinXMaxYCorner, .layerMaxXMaxYCorner)

    tableView.translatesAutoresizingMaskIntoConstraints = false
    return tableView
  }()

  private lazy var calendarAndContentStackView: UIStackView = {
    let stackView = UIStackView(arrangedSubviews: [
      calendarView,
      mealGokChallengeTableView,
    ])
    stackView.spacing = 0
    stackView.axis = .vertical

    stackView.layer.cornerRadius = 15
    stackView.layer.cornerCurve = .continuous

    stackView.addShadow()

    stackView.translatesAutoresizingMaskIntoConstraints = false
    return stackView
  }()

  private let contentScrollView: UIScrollView = {
    let scrollView = UIScrollView()

    scrollView.translatesAutoresizingMaskIntoConstraints = false
    return scrollView
  }()

  private lazy var contentStackView: UIStackView = {
    let stackView = UIStackView(arrangedSubviews: [
      settingButtonWithSpacer,
      headerStackView,
      calendarAndContentStackView,
    ])
    stackView.alignment = .fill
    stackView.axis = .vertical
    stackView.spacing = 15
    stackView.isLayoutMarginsRelativeArrangement = true
    stackView.layoutMargins = .init(top: 0, left: Metrics.leadingAndTrailingSpace, bottom: 100, right: Metrics.leadingAndTrailingSpace)

    stackView.translatesAutoresizingMaskIntoConstraints = false
    return stackView
  }()

  // MARK: Initializations

  init(viewModel: ProfileViewModelRepresentable, property: ProfileViewControllerProperty) {
    self.viewModel = viewModel
    profileViewControllerProperty = property
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
    contentScrollView.contentSize = contentStackView.bounds.size
  }
}

private extension ProfileViewController {
  func setup() {
    setupStyles()
    setupHierarchyAndConstraints()
    bind()
    setupTableViewDataSource()
    selectToday()

    requestMealGokHistory.send()
    updateProfileSubject.send()
  }

  func setupTableViewDataSource() {
    dataSource = .init(tableView: mealGokChallengeTableView) { tableView, indexPath, item in
      let tableViewCell = tableView.dequeueReusableCell(withIdentifier: ProfileViewMealGokTableViewCell.identifier, for: indexPath)
      guard let cell = tableViewCell as? ProfileViewMealGokTableViewCell else {
        return UITableViewCell()
      }
      cell.configure(challengeProperty: item)
      return cell
    }
  }

  func setupHierarchyAndConstraints() {
    let safeArea = view.safeAreaLayoutGuide

    view.addSubview(contentScrollView)

    contentScrollView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor).isActive = true
    contentScrollView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor).isActive = true
    contentScrollView.topAnchor.constraint(equalTo: safeArea.topAnchor).isActive = true
    contentScrollView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor).isActive = true

    contentScrollView.addSubview(contentStackView)

    contentStackView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor).isActive = true
    contentStackView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor).isActive = true

    mealGokChallengeTableView.heightAnchor.constraint(equalToConstant: 300).isActive = true
  }

  func setupStyles() {
    view.backgroundColor = DesignSystemColor.primaryBackground
  }

  func bind() {
    let output = viewModel.transform(input: .init(
      didChangeDate: didChangeDate.eraseToAnyPublisher(),
      fetchMealGokHistory: requestMealGokHistory.eraseToAnyPublisher(),
      showHistoryContent: requestHistoryContentViewController.eraseToAnyPublisher(),
      didTapSettingButton: settingButton.publisher(event: .touchUpInside).map { _ in return }.eraseToAnyPublisher(),
      updateProfile: updateProfileSubject.eraseToAnyPublisher()
    ))

    output
      .receive(on: DispatchQueue.main)
      .sink { [weak self] state in
        switch state {
        case .updateContent:
          break
        case let .updateMealGokChallengeHistoryDate(date):
          self?.updateDecoration(challengeDate: date)
        case let .updateTargetDayMealGokChallengeContent(property):
          self?.updateTableView(with: property)
        case let .showHistoryContent(property):
          self?.presentHistoryContentViewController(property)
        case let .updateProfile(name, imageURL, biography):
          self?.updateProfile(name: name, profileImageURL: imageURL, biography: biography)
        case .idle:
          break
        }
      }
      .store(in: &subscriptions)
  }

  func presentHistoryContentViewController(_ property: MealGokChallengeProperty) {
    guard
      let imageDataName = property.imageDateURL
    else {
      return
    }
    let imageDataURL = MealGokCacher.url(fileName: imageDataName)

    let imageView = UIImageView()
    imageView.setImage(url: imageDataURL, downSampleProperty: .init(size: .init(width: 500, height: 0)))

    Task {
      await imageView.fetchPublisher()?.sink { [weak self] status in
        switch status {
        case .finished:
          self?.presentHistoryContentViewController(
            image: imageView.image,
            property: .init(date: property.challengeDateString, title: property.mealTime())
          )
        default:
          break
        }
      }
    }
  }

  func presentHistoryContentViewController(image: UIImage?, property: HistoryContentPictureViewProperty) {
    let vc = HistoryViewController(
      property: property,
      contentImage: image
    )
    vc.modalTransitionStyle = .crossDissolve
    vc.modalPresentationStyle = .overFullScreen
    present(vc, animated: true)
  }

  func updateDecoration(challengeDate: [Date]) {
    challengeDate.forEach { dateComponent in decorations.insert(dateComponent) }
    let gregorian = Calendar(identifier: .gregorian)
    let challengeDateComponents = challengeDate.map { date in

      let year = gregorian.component(.year, from: date)
      let month = gregorian.component(.month, from: date)
      let day = gregorian.component(.day, from: date)

      return DateComponents(calendar: gregorian, year: year, month: month, day: day)
    }

    calendarView.reloadDecorations(forDateComponents: challengeDateComponents, animated: true)
  }

  func updateProfile(name: String, profileImageURL: URL?, biography: String) {
    headerStackView.profileNameLabel.text = name
    headerStackView.profileDescriptionLabel.text = biography
    headerStackView
      .profileImageView
      .setImage(url: profileImageURL, downSampleProperty: .init(size: .init(width: 30, height: 0)))
  }

  func updateTableView(with property: [MealGokChallengeProperty]) {
    guard var snapshot = dataSource?.snapshot() else {
      return
    }
    snapshot.appendItems(property)
    dataSource?.apply(snapshot)
  }

  func selectToday() {
    let now = Date.now

    // Select Today
    let today = DateComponents(
      calendar: Calendar(identifier: .gregorian),
      year: Calendar.current.component(.year, from: now),
      month: Calendar.current.component(.month, from: now),
      day: Calendar.current.component(.day, from: now)
    )
    calendarBehavior.setSelected(today, animated: true)

    guard var snapshot = dataSource?.snapshot() else {
      return
    }

    // apply today tableViewTitle
    snapshot.appendSections([today])
    dataSource?.apply(snapshot)

    // fetch Today MealGokHistory
    didChangeDate.send(today)
  }

  enum Metrics {
    static let topSpacing: CGFloat = 24

    static let headerCornerRadius: CGFloat = 8

    static let calendarMargin: CGFloat = 12

    static let leadingAndTrailingSpace: CGFloat = 24
    static let calendarViewTopSpacing: CGFloat = 36
  }

  enum Constants {
    static let localIdentifier = "ko_KR"

    static let settingButtonImage = "gearshape"

    static let profileNameLabelDfeaultText = "밀꼭꼭이"

    static let settingButtonImageFont = UIImage.SymbolConfiguration(font: .systemFont(ofSize: 23))

    static let gragorian = Calendar(identifier: .gregorian)

    /// Specify the starting date.
    static let fromDateComponents = DateComponents(
      calendar: gragorian,
      year: 2024,
      month: 1,
      day: 1
    )
    /// Specify the ending date.
    static let toDateComponents = DateComponents(
      calendar: gragorian,
      year: 2024,
      month: 12,
      day: 31
    )
  }
}

extension ProfileViewController {
  func updateSnapshot(with dateComponents: DateComponents?) {
    guard let dateComponents else { return }
    updateSection(with: dateComponents)
    didChangeDate.send(dateComponents)
  }

  private func updateSection(with dateComponents: DateComponents) {
    guard let dataSource else {
      return
    }

    var snapshot = dataSource.snapshot()
    snapshot.deleteAllItems()
    snapshot.appendSections([dateComponents])

    dataSource.apply(snapshot)
  }
}
