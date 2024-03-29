import UIKit

// MARK: - Routing

public protocol Routing: AnyObject {
  /// ParentRouter: it is ParentRouter,
  ///
  /// when you use This, should declare weak.
  /// if not you will get retain cycle.
  var parentRouter: Routing? { get set }

  var navigationController: UINavigationController? { get }

  var childRouters: [Routing] { get set }

  func start(build: UIViewController)
}

public extension Routing {
  /// Default PopRouter Method
  func popRouter() {
    let child = parentRouter?.childRouters.filter { self !== $0 }
    parentRouter?.childRouters = child ?? []

    childRouters.forEach { router in
      router.popRouter()
    }
    childRouters.removeAll()
  }
}
