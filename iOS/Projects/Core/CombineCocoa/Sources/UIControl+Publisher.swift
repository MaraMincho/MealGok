
import Combine
import UIKit

public extension UIControl {
  func publisher(event: UIControl.Event) -> EventPublisher {
    return EventPublisher(control: self, event: event)
  }

  struct EventPublisher: Publisher {
    public typealias Output = UIControl
    public typealias Failure = Never

    public func receive<S>(subscriber: S) where S: Subscriber, Never == S.Failure, UIControl == S.Input {
      let subscription = EventSubscription(subscriber: subscriber, control: control, event: event)
      subscriber.receive(subscription: subscription)
    }

    let control: UIControl
    let event: UIControl.Event

    init(control: UIControl, event: UIControl.Event) {
      self.control = control
      self.event = event
    }
  }
}
