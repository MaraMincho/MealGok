//
//  ProfileViewController+TableViewDelegate.swift
//  ProfileFeature
//
//  Created by MaraMincho on 2/4/24.
//  Copyright © 2024 com.maramincho. All rights reserved.
//

import CommonExtensions
import MealGokCacher
import UIKit

extension ProfileViewController: UITableViewDelegate {
  func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
    let cellHeight: CGFloat = 80
    return cellHeight
  }

  func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard
      let snapShot = dataSource?.snapshot(),
      let item = snapShot.itemIdentifiers[safe: indexPath.row]
    else {
      return
    }
    requestHistoryContentViewController.send(item)
  }
}
