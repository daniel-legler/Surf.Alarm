// Surf.Alarm

import Foundation
import UserNotifications

class NotificationScheduler {
  var alarm: SurfAlarm
  var forecast: SurfForecast

  var surfSpot: SurfSpot {
    guard let spot = alarm.surfSpot ?? forecast.surfSpot else {
      print("🌊 Error: Trying to schedule alarm without a surf spot in mind")
      fatalError()
    }
    return spot
  }

  init(alarm: SurfAlarm, forecast: SurfForecast) {
    self.alarm = alarm
    self.forecast = forecast
  }

  func schedule() {
    let request = notificationRequest(for: alarm, forecast: forecast)
    NotificationScheduler.addNotificationRequest(request)
  }

  #if DEBUG
    func scheduleTestNotification() {
      let request = UNNotificationRequest(identifier: surfSpot.name,
                                          content: notificationContent(for: forecast),
                                          trigger: UNTimeIntervalNotificationTrigger(timeInterval: 3.0, repeats: false))
      NotificationScheduler.addNotificationRequest(request)
    }
  #endif

  private func notificationRequest(for alarm: SurfAlarm, forecast: SurfForecast) -> UNNotificationRequest {
    return UNNotificationRequest(identifier: surfSpot.name,
                                 content: notificationContent(for: forecast),
                                 trigger: notificationTrigger(for: alarm))
  }

  private func notificationContent(for forecast: SurfForecast) -> UNNotificationContent {
    let content = UNMutableNotificationContent()
    content.title = "Time to surf!"
    content.body = "Waves are \(forecast.waveHeight.toSurfRange()) at \(surfSpot.name)"
    let soundName = UNNotificationSoundName(rawValue: "alarm.caf")
    content.sound = UNNotificationSound(named: soundName)
    content.badge = 1
    content.categoryIdentifier = SANotification.Category.alarm
    var userInfo = forecast.dictionaryWithValues(forKeys: ["waveHeight", "tideReport", "windReport"])
    userInfo["spotName"] = surfSpot.name
    content.userInfo = userInfo
    return content
  }

  private func notificationTrigger(for alarm: SurfAlarm) -> UNCalendarNotificationTrigger {
    var dateComponents = DateComponents()
    dateComponents.hour = alarm.hour
    dateComponents.minute = alarm.minute
    dateComponents.second = 0
    return UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
  }

  // MARK: Class Methods

  static func snooze(_ notification: UNNotification) {
    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 60 * 15, repeats: false)
    let request = UNNotificationRequest(identifier: notification.request.identifier,
                                        content: notification.request.content,
                                        trigger: trigger)
    addNotificationRequest(request)
  }

  static func cancel(_ alarm: SurfAlarm) {
    guard let spot = alarm.surfSpot else { return }
    UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [spot.name])
  }

  private static func addNotificationRequest(_ request: UNNotificationRequest) {
    UNUserNotificationCenter.current().add(request) { error in
      if let error = error {
        print("🌊 Error Scheduling Notification: \(error.localizedDescription)")
      } else {
        print("Notification Scheduled")
      }
    }
  }

  static func declareNotificationCategories() {
    let snoozeAction = UNNotificationAction(identifier: SANotification.Action.snooze,
                                            title: "Snooze for 15 minutes",
                                            options: UNNotificationActionOptions(rawValue: 0))
    let alarmCategory = UNNotificationCategory(identifier: SANotification.Category.alarm,
                                               actions: [snoozeAction],
                                               intentIdentifiers: [],
                                               hiddenPreviewsBodyPlaceholder: "",
                                               options: .customDismissAction)

    UNUserNotificationCenter.current().setNotificationCategories([alarmCategory])
  }
}
