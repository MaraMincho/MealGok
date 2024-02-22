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
  private var dataSource: UICollectionViewDiffableDataSource<Int, SettingTableViewProperty>?

  private let cellRegistration: UICollectionView.CellRegistration<UICollectionViewListCell, SettingTableViewProperty> =
    .init { cell, _, itemIdentifier in
      var configuration = UIListContentConfiguration.valueCell()
      configuration.text = itemIdentifier.titleText
      configuration.image = UIImage(systemName: itemIdentifier.imageSystemName)
      cell.backgroundColor = DesignSystemColor.secondaryBackground
      cell.accessories = [
        .disclosureIndicator(displayed: .always),
      ]

      cell.contentConfiguration = configuration
    }

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

  private lazy var contentCollectionView: UICollectionView = {
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: makeCompositionalLayout())
    collectionView.backgroundColor = .clear

    collectionView.translatesAutoresizingMaskIntoConstraints = false
    return collectionView
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
  func makeCompositionalLayout() -> UICollectionViewCompositionalLayout {
    return UICollectionViewCompositionalLayout { _, environment in
      let configuration = UICollectionLayoutListConfiguration(appearance: .grouped)
      let section = NSCollectionLayoutSection.list(using: configuration, layoutEnvironment: environment)
      return section
    }
  }

  func setup() {
    setupDataSource()
    setupViewHierarchyAndConstraints()
    setupStyles()
    bind()
    setFakeDataSource()
  }

  func setFakeDataSource() {
    guard var snapshot = dataSource?.snapshot() else {
      return
    }
    snapshot.appendSections([0])
    let buttonData: [(titleText: String, imageSystemName: String)] = [
      ("Home", "house.fill"),
      ("Settings", "gearshape.fill"),
      ("Profile", "person.fill"),
      ("Camera", "camera.fill"),
      ("Chat", "message.fill"),
      ("Music", "music.note.fill"),
      ("Map", "map.fill"),
      ("Calendar", "calendar"),
      ("Search", "magnifyingglass"),
      ("Clock", "clock.fill"),
      // 추가적으로 필요한 경우 계속해서 추가할 수 있습니다.
    ]
    snapshot.appendItems(buttonData.map { .init(titleText: $0.titleText, imageSystemName: $0.imageSystemName) })
    dataSource?.apply(snapshot)
  }

  func setupDataSource() {
    dataSource = .init(collectionView: contentCollectionView) { [weak self] collectionView, indexPath, itemIdentifier in
      guard let self else {
        return nil
      }
      let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
      return cell
    }
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

    view.addSubview(contentCollectionView)
    contentCollectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Metrics.tableViewTopSpacing).isActive = true
    contentCollectionView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor).isActive = true
    contentCollectionView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor).isActive = true
    contentCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
  }

  func setupStyles() {
    view.backgroundColor = DesignSystemColor.primaryBackground
  }

  func bind() {
    let output = viewModel.transform(input: .init(
      backButtonDidTap: backButton.publisher(event: .touchUpInside).map { _ in return }.eraseToAnyPublisher()
    ))
    output
      .subscribe(on: RunLoop.main)
      .sink { state in
        switch state {
        case .idle:
          break
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
}
