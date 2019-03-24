import Rswift
import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?

  func application(_: UIApplication, didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
    UIApplication.shared.setMinimumBackgroundFetchInterval(UIApplication.backgroundFetchIntervalMinimum)

    UNUserNotificationCenter.current().delegate = NotificationHandler.shared

    NotificationScheduler.declareNotificationCategories()

    if !UserDefaults.standard.bool(forKey: Constants.firstLaunchOccurred) {
      UserDefaults.standard.set(true, forKey: Constants.firstLaunchOccurred)
      NetworkService.refreshAllSurfSpots()
    }

    return true
  }

  func application(_: UIApplication, performFetchWithCompletionHandler _: @escaping (UIBackgroundFetchResult) -> Void) {
    AlarmService.shared.refreshAlarms()
  }

  func applicationDidEnterBackground(_: UIApplication) {
    #if DEBUG

      AlarmService.shared.testAlarm()

    #else

      AlarmService.shared.refreshAlarms()

    #endif
  }

  func applicationDidBecomeActive(_: UIApplication) {
    UIApplication.shared.applicationIconBadgeNumber = 0
  }
}
