// Surf.Alarm

import Foundation

extension Date {
    static func currentDayOfWeek() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        return formatter.string(from: Date())
    }
    
    static func alarmString(disabledWeekdays: [String]) -> String {
        let allWeekdays = Calendar.current.weekdaySymbols
        var missingWeekdays: [String?] = Calendar.current.shortWeekdaySymbols
        var missingIndices = [Int]()
        for day in disabledWeekdays {
            if let index = allWeekdays.index(of: day) {
                missingIndices.append(index)
            }
        }
        
        if missingIndices.sorted() == [0,6] {
            return "Weekdays"
        } else if missingIndices.sorted() == [1,2,3,4,5] {
            return "Weekends"
        }
        
        for index in missingIndices {
            missingWeekdays[index] = nil
        }
        
        return missingWeekdays.compactMap({$0}).joined(separator: " ")
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
