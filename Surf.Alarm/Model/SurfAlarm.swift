// Surf.Alarm

import Foundation
import RealmSwift

@objcMembers
class SurfAlarm: Object {
  dynamic var id: String = UUID().uuidString
  dynamic var minHeight: Int = 0
  dynamic var hour: Int = 8
  dynamic var minute: Int = 0
  dynamic var isEnabledByUser: Bool = true
  dynamic var surfSpot: SurfSpot?
  let disabledDays = List<String>()

  convenience init(spot: SurfSpot) {
    self.init()
    surfSpot = spot
  }

  override static func primaryKey() -> String? {
    return "id"
  }
}

extension SurfAlarm {
  var currentWeekdayIsEnabled: Bool {
    return !disabledDays.contains(Date.currentDayOfWeek())
  }

  var pickerDate: Date {
    var components = DateComponents()
    components.hour = hour
    components.minute = minute
    return Calendar.current.date(from: components) ?? Date()
  }
}
