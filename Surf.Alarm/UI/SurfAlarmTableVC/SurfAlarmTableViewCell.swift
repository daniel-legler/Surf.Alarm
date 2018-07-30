// Surf.Alarm

import UIKit

class SurfAlarmTableViewCell: UITableViewCell {

    @IBOutlet weak var spotLabel: UILabel!
    @IBOutlet weak var countyLabel: UILabel!
    @IBOutlet weak var surfHeightLabel: UILabel!
    @IBOutlet weak var calendarDays: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var enabledSwitch: UISwitch!
    
    weak var delegate: SurfAlarmTableViewCellDelegate?
    
    var surfAlarm: SurfAlarm! {
        didSet {
            self.spotLabel.text = surfAlarm.spotName
            self.countyLabel.text = surfAlarm.county
            self.surfHeightLabel.text = "\(surfAlarm.minHeight)+ ft"
            self.timeLabel.text = Date.alarmString(hour: surfAlarm.alarmHour,
                                                   minute: surfAlarm.alarmMinute)
            self.calendarDays.text = Date.alarmString(disabledWeekdays: Array(surfAlarm.disabledDays))
            self.enabledSwitch.isOn = surfAlarm.isEnabledByUser
        }
    }
    
    
    @IBAction func settingsTapped(_ sender: UIButton!) {
        self.delegate?.userTappedAlarmSettings(surfAlarm)
    }
    
    @IBAction func alarmSwitchChanged(_ sender: UISwitch) {
        store.setAlarmState(surfAlarm, enabled: sender.isOn)
    }
}

protocol SurfAlarmTableViewCellDelegate: class {
    func userTappedAlarmSettings(_ alarm: SurfAlarm)
}
