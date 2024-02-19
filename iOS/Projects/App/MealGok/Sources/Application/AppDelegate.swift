import DesignSystem
import OSLog
import SharedNotificationName
import UIKit
import UserNotifications

// MARK: - AppDelegate

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {
  var changeOrientation: Bool = false

  func application(_: UIApplication, didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
    addAppDelegateObserver()
    requestNotificationAuth()
    return true
  }

  func application(
    _: UIApplication,
    configurationForConnecting connectingSceneSession: UISceneSession,
    options _: UIScene.ConnectionOptions
  ) -> UISceneConfiguration {
    return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
  }

  func application(_: UIApplication, supportedInterfaceOrientationsFor _: UIWindow?) -> UIInterfaceOrientationMask {
    return changeOrientation ? [.all] : [.portrait]
  }
}

private extension AppDelegate {
  func addAppDelegateObserver() {
    NotificationCenter.default.addObserver(forName: .portraitScreenMode, object: nil, queue: .main) { _ in
      self.changeOrientation = false
    }
    NotificationCenter.default.addObserver(forName: .allScreenMode, object: nil, queue: .main) { _ in
      self.changeOrientation = true
    }
  }
}

// MARK: UNUserNotificationCenterDelegate

extension AppDelegate: UNUserNotificationCenterDelegate {
  func requestNotificationAuth() {
    let authOptions = UNAuthorizationOptions(arrayLiteral: .alert, .badge, .sound)

    UNUserNotificationCenter
      .current()
      .requestAuthorization(options: authOptions) { _, error in
        if let error {
          Logger().debug("\(#function) \(error.localizedDescription)")
        }
      }
  }

  func userNotificationCenter(
    _: UNUserNotificationCenter,
    didReceive _: UNNotificationResponse,
    withCompletionHandler completionHandler: @escaping () -> Void
  ) {
    _ = completionHandler()
  }

  func userNotificationCenter(
    _: UNUserNotificationCenter,
    willPresent _: UNNotification,
    withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
  ) {
    completionHandler([.list, .sound, .banner, .badge])
  }
}
