// Surf.Alarm

import Foundation
import RealmSwift

@objcMembers
class SurfAlarm: Object {
    
    dynamic var spotId: Int = 0
    dynamic var spotName: String = ""
    dynamic var county: String = ""
    dynamic var latitude: Double = 0.0
    dynamic var longitude: Double = 0.0
    dynamic var minHeight: Int = 0
    dynamic var alarmHour: Int = 8
    dynamic var alarmMinute: Int = 0
    dynamic var isEnabledByUser: Bool = true
    let disabledDays = List<String>()
    
    override static func primaryKey() -> String? {
        return "spotId"
    }
}

extension SurfAlarm {
    
    var currentWeekdayIsEnabled: Bool {
        return !disabledDays.contains(Date.currentDayOfWeek())
    }
    
    var date: Date {
        var components = DateComponents()
        components.hour = self.alarmHour
        components.minute = self.alarmMinute
        return Calendar.current.date(from: components) ?? Date()
    }
}
