//
//  PieChart.swift
//  MealTimerFeature
//
//  Created by MaraMincho on 1/31/24.
//  Copyright © 2024 com.maramincho. All rights reserved.
//

import DesignSystem
import UIKit

class PieChartView: UIView {
  let contentSize: CGSize
  var isInitiated: Bool = false

  private var startPoint = CGFloat(-Double.pi / 2)
  private var endPoint = CGFloat(3 * Double.pi / 2)

  init(contentSize: CGSize) {
    self.contentSize = contentSize
    super.init(frame: .zero)
  }

  override var intrinsicContentSize: CGSize {
    return contentSize
  }

  @available(*, unavailable)
  required init?(coder _: NSCoder) {
    fatalError("Cant use this method")
  }

  let shapeLayer = CAShapeLayer()
  var temp = CGFloat(-Double.pi / 2)

  var progress: CGFloat = 0
  func updatePieChart() {
    temp -= Double.pi / 8

    let center = CGPoint(x: bounds.midX, y: bounds.midY)
    let newPath = UIBezierPath()
    newPath.move(to: center)
    newPath.addArc(
      withCenter: center,
      radius: contentSize.width / 2,
      startAngle: startPoint,
      endAngle: temp,
      clockwise: false
    )
    newPath.close()

    let pathAnimation = CABasicAnimation(keyPath: "path")
    pathAnimation.fromValue = shapeLayer.path
    pathAnimation.toValue = newPath.cgPath
    pathAnimation.duration = 0.1
    pathAnimation.fillMode = .both
    pathAnimation.isRemovedOnCompletion = false

    shapeLayer.path = newPath.cgPath
    shapeLayer.fillColor = DesignSystemColor.main03.cgColor
    shapeLayer.lineWidth = 3

    layer.addSublayer(shapeLayer)
  }
}
