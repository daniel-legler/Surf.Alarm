// Surf.Alarm

import Foundation
import RealmSwift
import UserNotifications

class AlarmService: NSObject {
    
    static let shared = AlarmService()
    
    let alarms = store.allAlarms
    var token: NotificationToken?
    
    private override init() {
        super.init()
        token = alarms.observe({ (changes) in
            switch changes {
            case .update(_, _, _, let modifications):
                let updatedAlarmForecasts = modifications.map({self.alarms[$0]})
                for alarm in updatedAlarmForecasts {
                    self.scheduleAlarmNotifications(alarm)
                }
            default: break
            }
        })
    }
    
    deinit {
        self.token?.invalidate()
    }
    
    func refreshAlarms() {
        for alarm in alarms where alarm.isEnabledByUser {
            if let spot = alarm.surfSpot, spot.shouldRefresh {
                NetworkService.refreshForecast(for: spot)
            }
            self.scheduleAlarmNotifications(alarm)
        }
    }
    
    private func scheduleAlarmNotifications(_ alarm: SurfAlarm) {
        guard
            let spot = alarm.surfSpot,
            let forecast = store.currentSpotForecast(spot),
            shouldScheduleAlarmNotifications(alarm: alarm, forecast: forecast)
        else {
            NotificationScheduler.cancel(alarm)
            return
        }
        
        let scheduler = NotificationScheduler(alarm: alarm, forecast: forecast)
        scheduler.schedule()
    }
    
    private func shouldScheduleAlarmNotifications(alarm: SurfAlarm, forecast: SurfForecast) -> Bool {
        // Check alarm is enabled by user and forecast meets alarm conditions
        return alarm.isEnabledByUser &&
               alarm.currentWeekdayIsEnabled &&
               forecast.waveHeight >= Double(alarm.minHeight)
    }
}
