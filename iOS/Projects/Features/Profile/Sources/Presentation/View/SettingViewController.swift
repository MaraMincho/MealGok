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

// MARK: - SettingTableViewProperty

struct SettingTableViewProperty: Hashable {
  let titleText: String
  let imageSystemName: String
}

// MARK: - SettingViewController

final class SettingViewController: UITableViewController {
  // MARK: Properties

  private let viewModel: SettingViewModelRepresentable
  private var dataSource: UITableViewDiffableDataSource<Int, SettingTableViewProperty>?

  private var subscriptions: Set<AnyCancellable> = []

  override func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
    return Metrics.cellHeight
  }

  // MARK: Initializations

  init(viewModel: SettingViewModelRepresentable) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }

  deinit {
    print(Self.self, "deinit")
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
    setupStyles()
    bind()
  }

  func registerTableViewCell() {
    tableView.register(UITableViewCell.self, forHeaderFooterViewReuseIdentifier: Constants.identifier)
  }

  func setupDataSource() {
    dataSource = .init(tableView: tableView) { tableView, indexPath, itemIdentifier in
      let cell = tableView.dequeueReusableCell(withIdentifier: Constants.identifier, for: indexPath)
      var configure = cell.defaultContentConfiguration()
      configure.text = itemIdentifier.titleText
      configure.image = UIImage(systemName: itemIdentifier.imageSystemName)
      cell.contentConfiguration = configure

      return cell
    }
  }

  func setupStyles() {
    view.backgroundColor = DesignSystemColor.primaryBackground
    navigationItem.title = Constants.titleText
  }

  func bind() {
    let output = viewModel.transform(input: .init())
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
    static let cellHeight: CGFloat = 72
  }

  enum Constants {
    static let identifier: String = "SettingViewControllerCell"
    static let titleText: String = "설정"
  }
}
