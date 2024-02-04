//
//  ProfileViewController+UICalendarView.swift
//  ProfileFeature
//
//  Created by MaraMincho on 2/4/24.
//  Copyright © 2024 com.maramincho. All rights reserved.
//

import DesignSystem
import UIKit

// MARK: - ProfileViewController + UICalendarViewDelegate

extension ProfileViewController: UICalendarViewDelegate {
  func addCalendarDecoration() {
    addTodayDecoration()
  }

  private func addTodayDecoration() {
    let today = DateComponents(
      calendar: Calendar(identifier: .gregorian),
      year: 2024,
      month: 2,
      day: 4
    )
    decorations.insert(today.date)

    calendarBehavior.setSelected(today, animated: true)
  }

  func calendarView(_: UICalendarView, decorationFor dateComponents: DateComponents) -> UICalendarView.Decoration? {
    let date = DateComponents(
      calendar: dateComponents.calendar,
      year: dateComponents.year,
      month: dateComponents.month,
      day: dateComponents.day
    ).date

    if decorations.contains(date) {
      return makeDecoration()
    }
    return nil
  }

  private func makeDecoration() -> UICalendarView.Decoration {
    return .init {
      let view = UILabel()
      view.text = "🍚"
      return view
    }
  }
}

// MARK: - ProfileViewController + UICalendarSelectionSingleDateDelegate

extension ProfileViewController: UICalendarSelectionSingleDateDelegate {
  func dateSelection(_: UICalendarSelectionSingleDate, didSelectDate _: DateComponents?) {}
}
