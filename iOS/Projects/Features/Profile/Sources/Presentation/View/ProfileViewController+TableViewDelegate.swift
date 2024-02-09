//
//  ProfileViewController+TableViewDelegate.swift
//  ProfileFeature
//
//  Created by MaraMincho on 2/4/24.
//  Copyright © 2024 com.maramincho. All rights reserved.
//

import UIKit

extension ProfileViewController: UITableViewDelegate {
  func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
    let cellHeight: CGFloat = 80
    return cellHeight
  }
}
