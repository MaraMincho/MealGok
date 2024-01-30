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
  // MARK: - Property

  let contentSize: CGSize

  var lineCircleViewSize: CGSize {
    return .init(width: contentSize.width - 10, height: contentSize.height - 10)
  }

  var dashCircleViewSize: CGSize {
    let contentSize = lineCircleViewSize
    return .init(width: contentSize.width - 20, height: contentSize.height - 20)
  }

  // MARK: - UIComponent

  private lazy var lineCircleView: UIView = {
    let view = UIView()
    view.layer.borderWidth = 1
    view.layer.borderColor = DesignSystemColor.gray03.cgColor
    view.layer.cornerRadius = lineCircleViewSize.width / 2
    view.backgroundColor = DesignSystemColor.secondaryBackground

    return view
  }()

  private lazy var dashCircleView: UIView = {
    let view = UIView()
    view.layer.borderWidth = 0
    view.backgroundColor = DesignSystemColor.primaryBackground
    view.layer.cornerRadius = dashCircleViewSize.width / 2

    let shapeLayer = CAShapeLayer()
    shapeLayer.strokeColor = DesignSystemColor.gray03.cgColor
    shapeLayer.fillColor = DesignSystemColor.primaryBackground.cgColor
    shapeLayer.lineDashPattern = [4, 4]

    shapeLayer.path = UIBezierPath(roundedRect: .init(origin: .zero, size: dashCircleViewSize), cornerRadius: dashCircleViewSize.width / 2).cgPath

    view.layer.addSublayer(shapeLayer)

    return view
  }()

  private lazy var timerLabel: UILabel = {
    let label = UILabel()
    label.text = "20:00"
    label.textAlignment = .center
    label.textColor = DesignSystemColor.gray03
    label.font = .preferredFont(forTextStyle: .title1, weight: .bold)

    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()

  private let timerTitleLabel: UILabel = {
    let label = UILabel()
    label.textColor = DesignSystemColor.gray03

    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()

  private func setupViewHierarchyAndConstraints() {
    addSubview(lineCircleView)
    lineCircleView.frame.origin = .init(x: 5, y: 5)
    lineCircleView.frame.size = lineCircleViewSize

    lineCircleView.addSubview(dashCircleView)
    dashCircleView.frame.origin = .init(x: 10, y: 10)
    dashCircleView.frame.size = dashCircleViewSize

    addSubview(timerLabel)
    timerLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    timerLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
  }

  override var intrinsicContentSize: CGSize {
    return contentSize
  }

  // MARK: Initialization

  init(contentSize: CGSize) {
    self.contentSize = contentSize
    super.init(frame: .zero)
    setupViewHierarchyAndConstraints()
  }

  @available(*, unavailable)
  required init?(coder _: NSCoder) {
    fatalError("Cant use this method")
  }
}
