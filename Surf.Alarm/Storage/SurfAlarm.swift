// Surf.Alarm

import Foundation
import RealmSwift

@objcMembers
class SurfAlarm: Object {
    
    dynamic var spotId: Int = 0
    dynamic var spotName: String = ""
    dynamic var county: String = ""
    dynamic var minHeight: Int = 0
    dynamic var alarmHour: Int = -1
    dynamic var alarmMinute: Int = -1
    dynamic var isEnabledByUser: Bool = true
    let disabledDays = List<String>()
    
    override static func primaryKey() -> String? {
        return "spotId"
    }
    
    var currentWeekdayIsEnabled: Bool {
        return !disabledDays.contains(Date.currentDayOfWeek())
    }
}
