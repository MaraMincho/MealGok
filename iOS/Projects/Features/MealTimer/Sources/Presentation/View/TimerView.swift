//
//  TimerView.swift
//  MealTimerFeature
//
//  Created by MaraMincho on 1/30/24.
//  Copyright © 2024 com.maramincho. All rights reserved.
//

import DesignSystem
import UIKit

final class TimerView: UIView {
  private let lineCircleView: UIView = {
    let view = UIView()
    view.layer.borderWidth = 1
    view.layer.borderColor = DesignSystemColor.gray03.cgColor

    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()

  private let dashCircleView: UIView = {
    let view = UIView()
    view.layer.borderWidth = 1
    view.layer.borderColor = DesignSystemColor.gray03.cgColor
    view.backgroundColor = DesignSystemColor.primaryBackground

    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()

  private let timerTitleLabel: UILabel = {
    let label = UILabel()
    label.textColor = DesignSystemColor.gray03

    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()

  let contentSize: CGSize

  override var intrinsicContentSize: CGSize {
    return contentSize
  }

  // MARK: Initialization

  init(contentSize: CGSize) {
    self.contentSize = contentSize
    super.init(frame: .zero)
  }

  @available(*, unavailable)
  required init?(coder _: NSCoder) {
    fatalError("Cant use this method")
  }
}
