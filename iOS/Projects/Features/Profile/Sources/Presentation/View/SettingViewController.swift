//
//  SettingViewController.swift
//  ProfileFeature
//
//  Created by MaraMincho on 2/22/24.
//  Copyright © 2024 com.maramincho. All rights reserved.
//

import Combine
import DesignSystem
import UIKit

// MARK: - SettingViewController

final class SettingViewController: UIViewController {
  // MARK: Properties

  private let viewModel: SettingViewModelRepresentable
  private var dataSource: UITableViewDiffableDataSource<Int, SettingTableViewProperty>?

  private let didTapCellPublisher: PassthroughSubject<SettingTableViewProperty, Never> = .init()
  private var subscriptions: Set<AnyCancellable> = []

  // MARK: - UIComponent

  private let titleLabel: UILabel = {
    let label = UILabel()
    label.font = .preferredFont(forTextStyle: .title2)
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

  private lazy var tableView: UITableView = {
    let tableView = UITableView(frame: .zero, style: .grouped)
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: Constants.identifier)
    tableView.delegate = self
    tableView.tintColor = DesignSystemColor.main01
    tableView.backgroundColor = .clear

    tableView.translatesAutoresizingMaskIntoConstraints = false
    return tableView
  }()

  // MARK: - Initializations

  init(viewModel: SettingViewModelRepresentable) {
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

private extension SettingViewController {
  func setup() {
    setupDataSource()
    setupViewHierarchyAndConstraints()
    setupStyles()
    bind()
  }

  func updateSnapshotWith(settingTableViewProperties: [SettingTableViewProperty]) {
    guard var snapshot = dataSource?.snapshot() else {
      return
    }
    snapshot.appendSections([0])
    snapshot.appendItems(settingTableViewProperties)
    dataSource?.apply(snapshot, animatingDifferences: false)
  }

  func setupDataSource() {
    dataSource = .init(tableView: tableView, cellProvider: { tableView, _, itemIdentifier in
      guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.identifier) else {
        return UITableViewCell()
      }
      var configure = cell.defaultContentConfiguration()
      configure.image = UIImage(systemName: itemIdentifier.imageSystemName)
      configure.text = itemIdentifier.titleText
      cell.contentConfiguration = configure

      cell.accessoryType = .disclosureIndicator

      return cell
    })
  }

  func setupViewHierarchyAndConstraints() {
    let safeArea = view.safeAreaLayoutGuide

    view.addSubview(titleLabel)
    titleLabel.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 36).isActive = true
    titleLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor).isActive = true
    titleLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor).isActive = true

    view.addSubview(backButton)
    backButton.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor).isActive = true
    backButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor).isActive = true

    view.addSubview(tableView)
    tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Metrics.tableViewTopSpacing).isActive = true
    tableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor).isActive = true
    tableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor).isActive = true
    tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
  }

  func setupStyles() {
    view.backgroundColor = DesignSystemColor.primaryBackground
  }

  func bind() {
    let output = viewModel.transform(input: .init(
      backButtonDidTap: backButton.publisher(event: .touchUpInside).map { _ in return }.eraseToAnyPublisher(),
      didTapCell: didTapCellPublisher.eraseToAnyPublisher()
    ))
    output
      .subscribe(on: RunLoop.main)
      .sink { [weak self] state in
        switch state {
        case .idle:
          break
        case let .updateSettingViewProperties(properties):
          self?.updateSnapshotWith(settingTableViewProperties: properties)
        }
      }
      .store(in: &subscriptions)
  }

  enum Metrics {
    static let topSpacing: CGFloat = 24
    static let leadingAndTrailingConstraints: CGFloat = 24
    static let tableViewTopSpacing: CGFloat = 48

    static let cellHeight: CGFloat = 72
  }

  enum Constants {
    static let identifier: String = "SettingViewControllerCell"
    static let titleText: String = "설정"
    static let backButtonIconSystemName: String = "chevron.left"
  }
}

// MARK: UITableViewDelegate

extension SettingViewController: UITableViewDelegate {
  func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
    return Metrics.cellHeight
  }

  func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard
      let sectionItems = dataSource?.snapshot().itemIdentifiers(inSection: indexPath.section),
      let item = sectionItems[safe: indexPath.row]
    else {
      return
    }
    didTapCellPublisher.send(item)
  }
}
