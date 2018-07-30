// Surf.Alarm

import Foundation
import RealmSwift
import UserNotifications

class NotificationService {
    
    static let shared = NotificationService()
    
    var token: NotificationToken?
    
    private init() {
        token = alarms.observe({ (changes) in
            switch changes {
            case .update(_, let deletions, let insertions, let modifications):
                print("Do Something")
            }
        })
    }
    
    private deinit {
        self.token?.invalidate()
    }
    
    let alarms = store.allAlarms()
    
    func refreshForecastsForAlarms() {
        for alarm in alarms {
            if let spot = alarm.surfSpot, spot.shouldRefresh {
                NetworkService.refreshForecast(for: spot)
            }
        }
    }
    
    private func scheduleNotifications() {}
    
}
