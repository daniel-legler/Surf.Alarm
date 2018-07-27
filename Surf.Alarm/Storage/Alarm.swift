// Surf.Alarm

import Foundation
import RealmSwift

@objcMembers
class SurfAlarm: Object {
    
    dynamic var spotId: Int = 0
    dynamic var name: String = ""
    dynamic var county: String = ""
    dynamic var minHeight: Double = 0.0
    dynamic var maxHeight: Double = 0.0
    dynamic var alarmHour: Int = -1
    dynamic var alarmMinute: Int = -1
    dynamic var isEnabled: Bool = false
    
    override static func primaryKey() -> String? {
        return "spotId"
    }
}
