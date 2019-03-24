// Surf.Alarm

import UIKit
import UserNotifications

class NotificationHandler: NSObject, UNUserNotificationCenterDelegate {
  static let shared = NotificationHandler()

  private override init() {
    super.init()
  }

  func userNotificationCenter(
    _: UNUserNotificationCenter,
    didReceive response: UNNotificationResponse,
    withCompletionHandler completionHandler: @escaping () -> Void
  ) {
    switch response.actionIdentifier {
    case SANotification.Action.snooze:
      NotificationScheduler.snooze(response.notification)
    default:
      break
    }
    completionHandler()
  }
}
