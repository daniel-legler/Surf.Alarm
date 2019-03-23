// Surf.Alarm

import UIKit
import UserNotifications

class NotificationHandler: NSObject, UNUserNotificationCenterDelegate {

  static let shared = NotificationHandler()

  override private init() {
    super.init()
  }

  func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {

    switch response.actionIdentifier {
    case NotificationIdentifiers.Actions.snooze:
      NotificationScheduler.snooze(response.notification)
    default:
      break
    }
    completionHandler()
  }
}
