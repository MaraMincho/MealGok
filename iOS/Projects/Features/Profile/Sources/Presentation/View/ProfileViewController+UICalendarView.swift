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
  /// UICalendarViewDelegate 을 통해서, 만약 선택될 날짜가 있을 경우 데코레이션을 한다.
  func calendarView(_: UICalendarView, decorationFor dateComponents: DateComponents) -> UICalendarView.Decoration? {
    let day = DateComponents(
      calendar: dateComponents.calendar,
      year: dateComponents.year,
      month: dateComponents.month,
      day: dateComponents.day
    )

    return decorations.contains(day.date) ? makeDecoration() : nil
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
