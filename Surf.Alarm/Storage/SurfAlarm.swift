// Surf.Alarm

import Foundation
import RealmSwift

@objcMembers
class SurfAlarm: Object {
    
    dynamic var spotId: Int = 0
    dynamic var spotName: String = ""
    dynamic var county: String = ""
    dynamic var minHeight: Double = 0.0
    dynamic var alarmHour: Int = -1
    dynamic var alarmMinute: Int = -1
    dynamic var isEnabledByUser: Bool = true
    let disabledDays = List<String>()
    
    override static func primaryKey() -> String? {
        return "spotId"
    }
    
    var currentWeekdayIsEnabled: Bool {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        let dayOfWeek = formatter.string(from: Date())
        return !disabledDays.contains(dayOfWeek)
    }
}
