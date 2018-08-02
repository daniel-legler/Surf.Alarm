// Surf.Alarm

import Foundation
import UserNotifications

class NotificationScheduler {
    
    var alarm: SurfAlarm
    var forecast: SurfForecast
    var sound: UNNotificationSound
    
    init(alarm: SurfAlarm, forecast: SurfForecast) {
        self.alarm = alarm
        self.forecast = forecast
        self.sound = UNNotificationSound(named: "alarm.caf")
    }
    
    func schedule() {
        let request = self.notificationRequest(for: alarm, forecast: forecast)
        NotificationScheduler.addNotificationRequest(request)
    }
    
    func scheduleTestNotification() {
        let request = UNNotificationRequest(identifier: alarm.spotName,
                                            content: self.notificationContent(for: forecast),
                                            trigger: UNTimeIntervalNotificationTrigger(timeInterval: 3.0, repeats: false))
        NotificationScheduler.addNotificationRequest(request)
    }
    
    private func notificationRequest(for alarm: SurfAlarm, forecast: SurfForecast) -> UNNotificationRequest {
       return UNNotificationRequest(identifier: alarm.spotName,
                                    content: self.notificationContent(for: forecast),
                                    trigger: self.notificationTrigger(for: alarm))
    }
    
    private func notificationContent(for forecast: SurfForecast) -> UNNotificationContent {
        let content = UNMutableNotificationContent()
        content.title = "Time to surf!"
        content.body = "Waves are \(forecast.waveHeight.toSurfRange()) at \(forecast.spotName)"
        content.sound = self.sound
        content.badge = 1
        content.categoryIdentifier = NotificationIdentifiers.Categories.alarm
        content.userInfo = forecast.dictionaryWithValues(forKeys: ["spotName","waveHeight","tideReport","windReport"])
        return content
    }
    
    private func notificationTrigger(for alarm: SurfAlarm) -> UNCalendarNotificationTrigger {
        var dateComponents = DateComponents()
        dateComponents.hour = alarm.alarmHour
        dateComponents.minute = alarm.alarmMinute
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
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [alarm.spotName])
    }
    
    private static func addNotificationRequest(_ request: UNNotificationRequest) {
        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error {
                print("🌊 Error Scheduling Notification: \(error.localizedDescription)")
            } else {
                print("Notification Scheduled")
            }
        }
    }

    static func declareNotificationCategories() {
        let snoozeAction = UNNotificationAction(identifier: NotificationIdentifiers.Actions.snooze,
                                                title: "Snooze for 15 minutes",
                                                options: UNNotificationActionOptions(rawValue: 0))
        let alarmCategory = UNNotificationCategory(identifier: NotificationIdentifiers.Categories.alarm,
                                                   actions: [snoozeAction],
                                                   intentIdentifiers: [],
                                                   hiddenPreviewsBodyPlaceholder: "",
                                                   options: .customDismissAction)
        
        UNUserNotificationCenter.current().setNotificationCategories([alarmCategory])
    }
}
