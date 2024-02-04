//
//  ProfileViewMealGokTableViewCell.swift
//  ProfileFeature
//
//  Created by MaraMincho on 2/4/24.
//  Copyright © 2024 com.maramincho. All rights reserved.
//

import UIKit

final class ProfileViewMealGokTableViewCell: UITableViewCell {
  static let identifier = "ProfileViewMealGokTableViewCell"

  override init(style _: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: .default, reuseIdentifier: reuseIdentifier)
  }

  @available(*, unavailable)
  required init?(coder _: NSCoder) {
    fatalError("Cant use this method")
  }

  func configure() {
    var configuration = defaultContentConfiguration()
    configuration.text = "성공"
    configuration.image = .init(systemName: "star.fill")
    configuration.secondaryText = "AM 09:00 ~ 09:20"

    contentConfiguration = configuration
  }
}
