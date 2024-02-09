//
//  ProfileViewMealGokDataSource.swift
//  ProfileFeature
//
//  Created by MaraMincho on 2/4/24.
//  Copyright © 2024 com.maramincho. All rights reserved.
//

import UIKit

class ProfileViewMealGokDataSource: UITableViewDiffableDataSource<DateComponents, MealGokChallengeProperty> {
  override func tableView(_: UITableView, titleForHeaderInSection section: Int) -> String? {
    let snapshot = snapshot()
    let component = snapshot.sectionIdentifiers[section]

    return "\(component.year?.description ?? "")년 \(component.month?.description ?? "")월 \(component.day?.description ?? "")일"
  }
}
