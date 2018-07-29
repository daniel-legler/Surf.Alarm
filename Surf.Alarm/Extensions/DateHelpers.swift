// Surf.Alarm

import Foundation

extension Date {
    static func currentDayOfWeek() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        return formatter.string(from: Date())
    }
    
    static func alarmString(hour: Int, minute: Int) -> String {
        let postfix = (hour < 12 || hour == 24) ? "AM" : "PM"
        let min = minute < 10 ? "0\(minute)" : "\(minute)"
        var hr = hour
        if hour > 12 {
            hr -= 12
        } else if hour == 0 {
            hr += 12
        }
        return "\(hr):\(min) " + postfix
    }

}
