//
//  ProfileViewController.swift
//  ProfileFeature
//
//  Created by MaraMincho on 2/3/24.
//  Copyright © 2024 com.maramincho. All rights reserved.
//

import Combine
import DesignSystem
import UIKit

// MARK: - ProfileViewControllerProperty

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

    button.translatesAutoresizingMaskIntoConstraints = false
    return button
  }()

  private let profileImageView: UIImageView = {
    let image = UIImage(systemName: "person.fill")
    let imageView = UIImageView(image: image)
    imageView.layer.cornerRadius = Metrics.imageViewWidthAndHeight / 2
    imageView.layer.masksToBounds = false
    imageView.layer.cornerCurve = .continuous
    imageView.layer.borderColor = DesignSystemColor.main01.cgColor
    imageView.layer.borderWidth = Metrics.imageViewBorderWidth

    imageView.clipsToBounds = true

    imageView.translatesAutoresizingMaskIntoConstraints = false
    return imageView
  }()

  private let profileNameLabel: UILabel = {
    let label = UILabel()
    label.font = .preferredFont(forTextStyle: .title1)
    label.text = Constants.profileNameLabelDfeaultText
    label.textColor = DesignSystemColor.primaryText

    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()

  private lazy var profileAndNameStackView: UIStackView = {
    let stackView = UIStackView(arrangedSubviews: [
      self.profileImageView,
      self.profileNameLabel,
    ])
    stackView.axis = .horizontal
    stackView.alignment = .center
    stackView.spacing = Metrics.profileAndNameLabelSpacing

    stackView.translatesAutoresizingMaskIntoConstraints = false
    return stackView
  }()

  private let profileDescriptionLabel: UILabel = {
    let label = UILabel()
    label.font = .preferredFont(forTextStyle: .body, weight: .medium)
    label.text = "안녕하세요 좋은 아침"
    label.textColor = DesignSystemColor.primaryText
    label.numberOfLines = 4

    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()

  private lazy var headerStackView: UIStackView = {
    let stackView = UIStackView(arrangedSubviews: [
      self.profileAndNameStackView,
      self.profileDescriptionLabel,
    ])
    stackView.axis = .vertical
    stackView.alignment = .fill
    stackView.spacing = Metrics.profileAndDescriptionLabelSpacing
    stackView.layoutMargins = .init(
      top: 0,
      left: Metrics.leadingAndTrailingSpace,
      bottom: 0,
      right: Metrics.leadingAndTrailingSpace
    )
    stackView.isLayoutMarginsRelativeArrangement = true

    stackView.translatesAutoresizingMaskIntoConstraints = false
    return stackView
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
    tableView.register(ProfileViewMealGokTableViewCell.self, forCellReuseIdentifier: ProfileViewMealGokTableViewCell.identifier)

    tableView.translatesAutoresizingMaskIntoConstraints = false
    return tableView
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
}

private extension ProfileViewController {
  func setup() {
    setupStyles()
    setupHierarchyAndConstraints()
    bind()
    addCalendarDecoration()
    setupTableViewDataSource()
  }

  func setupTableViewDataSource() {
    dataSource = .init(tableView: mealGokChallengeTableView) { tableView, indexPath, _ in
      let tableViewCell = tableView.dequeueReusableCell(withIdentifier: ProfileViewMealGokTableViewCell.identifier, for: indexPath)
      guard let cell = tableViewCell as? ProfileViewMealGokTableViewCell else {
        return nil
      }
      cell.configure()
      return cell
    }

    if var snapshot = dataSource?.snapshot() {
      snapshot.appendSections([.init(calendar: .init(identifier: .gregorian), year: 2024, month: 2, day: 4)])
      dataSource?.apply(snapshot)
      setFakeDataSource()
    }
  }

  func setFakeDataSource() {
    if var snapshot = dataSource?.snapshot() {
      snapshot.appendItems([.init(), .init(), .init()])
      dataSource?.apply(snapshot)
    }
  }

  func setupHierarchyAndConstraints() {
    let safeArea = view.safeAreaLayoutGuide

    view.addSubview(settingButton)
    settingButton.trailingAnchor
      .constraint(equalTo: safeArea.trailingAnchor, constant: -Metrics.leadingAndTrailingSpace).isActive = true
    settingButton.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: Metrics.topSpacing).isActive = true

    view.addSubview(headerStackView)
    headerStackView.topAnchor
      .constraint(equalTo: settingButton.bottomAnchor, constant: Metrics.headerStackViewTopSpacing).isActive = true
    headerStackView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor).isActive = true
    headerStackView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor).isActive = true

    profileImageView.widthAnchor.constraint(equalToConstant: Metrics.imageViewWidthAndHeight).isActive = true
    profileImageView.heightAnchor.constraint(equalToConstant: Metrics.imageViewWidthAndHeight).isActive = true

    view.addSubview(calendarView)
    calendarView.leadingAnchor
      .constraint(equalTo: safeArea.leadingAnchor, constant: Metrics.leadingAndTrailingSpace).isActive = true
    calendarView.trailingAnchor
      .constraint(equalTo: safeArea.trailingAnchor, constant: -Metrics.leadingAndTrailingSpace).isActive = true
    calendarView.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: Metrics.calendarViewTopSpacing).isActive = true

    view.addSubview(mealGokChallengeTableView)
    mealGokChallengeTableView.topAnchor.constraint(equalTo: calendarView.bottomAnchor, constant: 12).isActive = true
    mealGokChallengeTableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor).isActive = true
    mealGokChallengeTableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor).isActive = true
    mealGokChallengeTableView.heightAnchor.constraint(equalToConstant: 300).isActive = true
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
    static let topSpacing: CGFloat = 24

    static let headerStackViewTopSpacing: CGFloat = 12

    static let imageViewWidthAndHeight: CGFloat = 72
    static let imageViewBorderWidth: CGFloat = 2
    static let profileAndNameLabelSpacing: CGFloat = 12
    static let profileAndDescriptionLabelSpacing: CGFloat = 12

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
