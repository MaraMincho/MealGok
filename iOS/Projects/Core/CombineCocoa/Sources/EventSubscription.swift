//
//  EventSubscription.swift
//  CombineCocoa
//
//  Created by MaraMincho on 1/31/24.
//  Copyright © 2024 com.maramincho. All rights reserved.
//

import Combine
import UIKit

public final class EventSubscription<T: Subscriber>: Subscription where T.Input == UIControl, T.Failure == Never {
  public func request(_: Subscribers.Demand) {}

  public func cancel() {
    subscriber = nil
    control.removeAction(controlAction, for: event)
  }

  var subscriber: T?
  var control: UIControl
  var event: UIControl.Event
  var controlAction: UIAction

  init(subscriber: T, control: UIControl, event: UIControl.Event) {
    self.subscriber = subscriber
    self.control = control
    self.event = event

    controlAction = .init { _ in
      _ = subscriber.receive(control)
    }

    control.addAction(controlAction, for: event)
  }
}
