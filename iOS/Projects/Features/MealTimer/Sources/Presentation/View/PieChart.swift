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
    shapeLayer.fillColor = DesignSystemColor.main03.cgColor
    layer.addSublayer(shapeLayer)
  }

  override var intrinsicContentSize: CGSize {
    return contentSize
  }

  @available(*, unavailable)
  required init?(coder _: NSCoder) {
    fatalError("Cant use this method")
  }

  let shapeLayer = CAShapeLayer()
  let pulseLayer = CAShapeLayer()

  func heartBeatAnimation() {
    updatePieChart(radian: 2 * .pi)
    let scaleAnimation = CABasicAnimation(keyPath: "transform.scale.xy")
    scaleAnimation.fromValue = 1
    scaleAnimation.toValue = 1.2

    let opacityAnimation = CAKeyframeAnimation(keyPath: "opacity")
    opacityAnimation.values = [0.3, 0.7, 0]
    opacityAnimation.keyTimes = [0, 0.3, 1]

    let animationGroup = CAAnimationGroup()
    animationGroup.duration = 1.5
    animationGroup.repeatCount = .infinity
    animationGroup.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.default)
    animationGroup.animations = [scaleAnimation, opacityAnimation]

    layer.add(animationGroup, forKey: "pulse")
  }

  func updatePieChart(radian: Double) {
    let center = CGPoint(x: bounds.midX, y: bounds.midY)
    let newPath = UIBezierPath()
    newPath.move(to: center)
    newPath.addArc(
      withCenter: center,
      radius: contentSize.width / 2,
      startAngle: startPoint,
      endAngle: startPoint - radian,
      clockwise: false
    )
    newPath.close()

    shapeLayer.path = newPath.cgPath
    shapeLayer.lineWidth = 3
  }
}
