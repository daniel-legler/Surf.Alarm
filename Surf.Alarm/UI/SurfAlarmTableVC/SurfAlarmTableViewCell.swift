// Surf.Alarm

import UIKit

class SurfAlarmTableViewCell: UITableViewCell {

    @IBOutlet weak var spotLabel: UILabel!
    @IBOutlet weak var countyLabel: UILabel!
    @IBOutlet weak var surfHeightLabel: UILabel!
    @IBOutlet weak var calendarDays: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    var surfAlarm: SurfAlarm! {
        didSet {
            self.spotLabel.text = surfAlarm.spotName
            self.countyLabel.text = surfAlarm.county
            self.surfHeightLabel.text = "\(surfAlarm.minHeight)+ ft"
            self.timeLabel.text = Date.alarmString(hour: surfAlarm.alarmHour,
                                                   minute: surfAlarm.alarmMinute)
            
        }
    }
    
    
    @IBAction func settingsTapped(_ sender: UIButton!) {
        
    }
    
    @IBAction func alarmSwitchChanged(_ sender: UISwitch) {
    
    }
}
