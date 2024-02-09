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
    let now = Date.now

    // Select Today
    let today = DateComponents(
      calendar: Calendar(identifier: .gregorian),
      year: Calendar.current.component(.year, from: now),
      month: Calendar.current.component(.month, from: now),
      day: Calendar.current.component(.day, from: now)
    )
    decorations.insert(today.date)
  }

  /// UICalendarViewDelegate 을 통해서, 만약 선택될 날짜가 있을 경우 데코레이션을 한다.
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
  func dateSelection(_: UICalendarSelectionSingleDate, didSelectDate date: DateComponents?) {
    updateSnapshot(with: date)
  }
}
