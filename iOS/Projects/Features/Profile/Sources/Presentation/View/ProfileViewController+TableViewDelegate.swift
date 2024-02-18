//
//  ProfileViewController+TableViewDelegate.swift
//  ProfileFeature
//
//  Created by MaraMincho on 2/4/24.
//  Copyright © 2024 com.maramincho. All rights reserved.
//

import ImageManager
import UIKit

extension ProfileViewController: UITableViewDelegate {
  func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
    let cellHeight: CGFloat = 80
    return cellHeight
  }

  func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard
      let snapShot = dataSource?.snapshot(),
      let imageDataName = snapShot.itemIdentifiers[indexPath.row].imageDateURL
    else {
      return
    }
    let item = snapShot.itemIdentifiers[indexPath.row]
    let imageDataURL = MealGokCacher.url(fileName: imageDataName)
    let vc = HistoryViewController(property: .init(date: item.challengeDate(), pictureURL: imageDataURL, title: item.mealTime()))
    vc.modalTransitionStyle = .crossDissolve
    vc.modalPresentationStyle = .overFullScreen
    present(vc, animated: true)
  }
}
