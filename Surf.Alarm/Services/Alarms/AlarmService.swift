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
    token = alarms.observe { changes in
      switch changes {
      case let .update(_, _, _, modifications):
        let updatedAlarmForecasts = modifications.map { self.alarms[$0] }
        for alarm in updatedAlarmForecasts {
          self.scheduleAlarmNotifications(alarm)
        }
      default: break
      }
    }
  }

  deinit {
    self.token?.invalidate()
  }

  #if DEBUG
    func testAlarm() {
      guard let alarm = alarms.first,
            let spot = alarm.surfSpot,
            let forecast = store.currentSpotForecast(spot) else {
        return
      }

      let scheduler = NotificationScheduler(alarm: alarm, forecast: forecast)
      scheduler.scheduleTestNotification()
    }
  #endif

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
      shouldScheduleNotifications(for: alarm, forecast: forecast)
    else {
      NotificationScheduler.cancel(alarm)
      return
    }

    let scheduler = NotificationScheduler(alarm: alarm, forecast: forecast)
    scheduler.schedule()
  }

  private func shouldScheduleNotifications(for alarm: SurfAlarm, forecast: SurfForecast) -> Bool {
    return alarm.isEnabledByUser &&
      alarm.currentWeekdayIsEnabled &&
      forecast.waveHeight >= Double(alarm.minHeight)
  }
}
