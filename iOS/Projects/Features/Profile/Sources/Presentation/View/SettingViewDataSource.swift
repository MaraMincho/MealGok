//
//  SettingViewDataSource.swift
//  ProfileFeature
//
//  Created by MaraMincho on 2/22/24.
//  Copyright © 2024 com.maramincho. All rights reserved.
//

import UIKit

// MARK: - SettingTableViewProperty

struct SettingTableViewProperty: Hashable {
  let titleText: String
  let imageSystemName: String
}

// MARK: - SettingViewDataSource

class SettingViewDataSource: UITableViewDiffableDataSource<Int, SettingTableViewProperty> {
  var titleString: String?
  override func tableView(_: UITableView, titleForHeaderInSection _: Int) -> String? {
    return titleString
  }

  func setTitleString(_ text: String) {
    titleString = text
  }
}
