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

  func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard
      let snapShot = dataSource?.snapshot(),
      let imageDataURLString = snapShot.itemIdentifiers[indexPath.row].imageDateURL,
      let imageDataURL = URL(string: imageDataURLString)
    else {
      return
    }
    do {
      let imageData = try Data(contentsOf: imageDataURL)
      let vc = UIViewController()
      let imageView = UIImageView()
      imageView.image = UIImage(data: imageData)
      vc.view = imageView
      present(vc, animated: true)
    }catch {
      fatalError("Cant load DataContent")
    }
    
  }
}
