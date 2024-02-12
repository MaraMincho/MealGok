import DesignSystem
import SharedNotificationName
import UIKit

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {
  func application(_: UIApplication, didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
    addAppDelegateObserver()
    return true
  }

  func application(
    _: UIApplication,
    configurationForConnecting connectingSceneSession: UISceneSession,
    options _: UIScene.ConnectionOptions
  ) -> UISceneConfiguration {
    return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
  }

  var changeOrientation: Bool = false
  func application(_: UIApplication, supportedInterfaceOrientationsFor _: UIWindow?) -> UIInterfaceOrientationMask {
    return changeOrientation ? [.all] : [.portrait]
  }

  func addAppDelegateObserver() {
    NotificationCenter.default.addObserver(forName: .portraitScreenMode, object: nil, queue: .main) { _ in
      self.changeOrientation = false
    }
    NotificationCenter.default.addObserver(forName: .allScreenMode, object: nil, queue: .main) { _ in
      self.changeOrientation = true
    }
  }
}
