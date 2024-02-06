//
//  TimerView.swift
//  MealTimerFeature
//
//  Created by MaraMincho on 1/30/24.
//  Copyright © 2024 com.maramincho. All rights reserved.
//

import DesignSystem
import UIKit

// MARK: - TimerView

final class TimerView: UIView {
  // MARK: - Property

  private let contentSize: CGSize

  private var lineCircleViewSize: CGSize {
    return .init(width: contentSize.width, height: contentSize.height)
  }

  private var dashCircleViewSize: CGSize {
    let contentSize = lineCircleViewSize
    return .init(width: contentSize.width - 20, height: contentSize.height - 20)
  }

  private var pieChartViewSize: CGSize {
    let contentSize = lineCircleViewSize
    return .init(width: contentSize.width - 15, height: contentSize.height - 15)
  }

  // MARK: - UIComponent

  lazy var lineCircleView: UIView = {
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

  private lazy var pieChartView = PieChartView(contentSize: pieChartViewSize)

  private let timerMinuteLabel: UILabel = {
    let label = UILabel()
    label.textColor = DesignSystemColor.gray03
    label.font = .preferredFont(forTextStyle: .title1, weight: .bold)
    label.text = " "
    label.textAlignment = .left

    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()

  /// TimerView의 정 가운데 배치 됩니다.
  private let timerColonLabel: UILabel = {
    let label = UILabel()
    label.textColor = DesignSystemColor.gray03
    label.font = .preferredFont(forTextStyle: .title1, weight: .bold)
    label.textAlignment = .center
    label.text = ":"
    label.numberOfLines = 2

    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()

  private let timerSecondsLabel: UILabel = {
    let label = UILabel()
    label.textColor = DesignSystemColor.gray03
    label.font = .preferredFont(forTextStyle: .title1, weight: .bold)
    label.textAlignment = .right
    label.text = " "

    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()

  private let finishLabel: UILabel = {
    let label = UILabel()
    label.text = "성공!"
    label.textColor = DesignSystemColor.gray03
    label.font = .preferredFont(forTextStyle: .title1, weight: .bold)
    label.isHidden = true

    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()

  private func setupViewHierarchyAndConstraints() {
    addSubview(lineCircleView)
    lineCircleView.frame.origin = .init(x: 0, y: 0)
    lineCircleView.frame.size = lineCircleViewSize

    lineCircleView.addSubview(dashCircleView)
    dashCircleView.frame.origin = .init(x: 10, y: 10)
    dashCircleView.frame.size = dashCircleViewSize

    addSubview(pieChartView)
    pieChartView.frame.origin = .init(x: 7.5, y: 7.5)
    pieChartView.frame.size = pieChartViewSize

    addSubview(timerColonLabel)
    timerColonLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    timerColonLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true

    addSubview(timerMinuteLabel)
    timerMinuteLabel.topAnchor.constraint(equalTo: timerColonLabel.topAnchor).isActive = true
    timerMinuteLabel.trailingAnchor.constraint(equalTo: timerColonLabel.leadingAnchor).isActive = true

    addSubview(timerSecondsLabel)
    timerSecondsLabel.leadingAnchor.constraint(equalTo: timerColonLabel.trailingAnchor).isActive = true
    timerSecondsLabel.topAnchor.constraint(equalTo: timerColonLabel.topAnchor).isActive = true

    addSubview(finishLabel)
    finishLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    finishLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
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

extension TimerView {
  func updateTimerCenterDescription(text: String?) {
    timerColonLabel.text = text
  }

  func updateTimerLabel(minutes: String?, seconds: String?) {
    timerMinuteLabel.text = minutes
    timerSecondsLabel.text = seconds
  }

  func updateFan(to radian: Double?) {
    guard let radian else { return }
    pieChartView.updatePieChart(radian: radian)
  }

  func didFinish() {
    setView(finishLabel, hidden: false)

    setView(timerMinuteLabel, hidden: true)
    setView(timerColonLabel, hidden: true)
    setView(timerSecondsLabel, hidden: true)

    pieChartView.heartBeatAnimation()
  }

  private func setView(_ view: UIView, hidden: Bool) {
    UIView.transition(with: view, duration: 1.5, options: .transitionCrossDissolve, animations: {
      view.isHidden = hidden
    })
  }
}
