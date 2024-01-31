//
//  UIView+Publisher.swift
//  CombineCocoa
//
//  Created by MaraMincho on 1/31/24.
//  Copyright © 2024 com.maramincho. All rights reserved.
//

import Combine
import UIKit

public extension UIView {
  func publisher(gesture: GestureType) -> GesturePublisher {
    return GesturePublisher(targetView: self, gesture: gesture.recognizer)
  }

  struct GesturePublisher: Publisher {
    public typealias Output = UIGestureRecognizer
    public typealias Failure = Never

    private let targetView: UIView
    private let gesture: UIGestureRecognizer

    public init(targetView: UIView, gesture: UIGestureRecognizer) {
      self.targetView = targetView
      self.gesture = gesture
    }

    public func receive<S>(subscriber: S) where S: Subscriber, Never == S.Failure, UIGestureRecognizer == S.Input {
      let subscription = GestureSubscription(subscriber: subscriber, gesture: gesture, targetView: targetView)
      subscriber.receive(subscription: subscription)
    }
  }

  enum GestureType {
    case tap
    case swipe
    case longPress
    case pan
    case pinch
    case edge

    var recognizer: UIGestureRecognizer {
      switch self {
      case .tap:
        return UITapGestureRecognizer()
      case .swipe:
        return UISwipeGestureRecognizer()
      case .longPress:
        return UILongPressGestureRecognizer()
      case .pan:
        return UIPanGestureRecognizer()
      case .pinch:
        return UIPinchGestureRecognizer()
      case .edge:
        return UIScreenEdgePanGestureRecognizer()
      }
    }
  }
}
