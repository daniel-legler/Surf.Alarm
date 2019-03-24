// Surf.Alarm

import UIKit
import UserNotifications

class NotificationAuthorizer {
  static var userDisabledNotifications: Bool {
    get {
      return UserDefaults.standard.bool(forKey: Constants.userDisabledNotifications)
    } set {
      UserDefaults.standard.set(newValue, forKey: Constants.userDisabledNotifications)
    }
  }

  static func checkAuthorization(_ result: @escaping (Bool) -> Void) {
    UNUserNotificationCenter.current().getNotificationSettings { settings in
      switch settings.authorizationStatus {
      case .authorized:
        userDisabledNotifications = false
        result(true)
      case .denied, .provisional:
        result(false)
      case .notDetermined:
        requestAuthorization()
      }
    }
  }

  private static func requestAuthorization() {
    let options: UNAuthorizationOptions = [.alert, .sound, .badge]
    UNUserNotificationCenter.current().requestAuthorization(options: options) { _, _ in }
  }
}
