// Surf.Alarm

import Foundation
import UserNotifications

class NotificationScheduler {
    
    var alarm: SurfAlarm
    var forecast: SurfForecast
    
    var sound: UNNotificationSound = .default()
    
    init(alarm: SurfAlarm, forecast: SurfForecast) {
        self.alarm = alarm
        self.forecast = forecast
    }
    
    func schedule() {
        let request = self.notification(for: alarm, forecast: forecast)
        UNUserNotificationCenter.current().add(request) { (error) in
            if error != nil {
                print("🌊 Error Scheduling Notification: \(String(describing: error!.localizedDescription))")
            } else {
                print("Notification alarm is now scheduled")
            }
        }
    }
    
    private func notification(for alarm: SurfAlarm, forecast: SurfForecast) -> UNNotificationRequest {
       return UNNotificationRequest(identifier: alarm.spotName,
                                    content: self.notificationContent(for: forecast),
                                    trigger: self.notificationTrigger(for: alarm))
    }
    
    private func notificationContent(for forecast: SurfForecast) -> UNNotificationContent {
        let content = UNMutableNotificationContent()
        content.title = "Time to surf!"
        content.body = "Waves are \(forecast.waveHeight.toSurfRange()) at \(forecast.spotName)"
        content.sound = self.sound
        return content
    }
    
    private func notificationTrigger(for alarm: SurfAlarm) -> UNCalendarNotificationTrigger {
        var dateComponents = DateComponents()
        dateComponents.hour = alarm.alarmHour
        dateComponents.minute = alarm.alarmMinute
        dateComponents.second = 0
        return UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
    }
    
    static func cancel(_ alarm: SurfAlarm) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [alarm.spotName])
    }

}
