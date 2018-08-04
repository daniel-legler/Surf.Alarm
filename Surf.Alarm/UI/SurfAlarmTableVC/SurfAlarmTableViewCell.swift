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
            self.spotLabel.text = surfAlarm.surfSpot?.name
            self.countyLabel.text = surfAlarm.surfSpot?.county
            self.surfHeightLabel.text = "\(surfAlarm.minHeight)+ ft"
            self.timeLabel.text = Date.alarmString(hour: surfAlarm.hour,
                                                   minute: surfAlarm.minute)
            self.calendarDays.text = Date.alarmString(disabledWeekdays: Array(surfAlarm.disabledDays))
            self.enabledSwitch.isOn = surfAlarm.isEnabledByUser
        }
    }
    
    
    @IBAction func settingsTapped(_ sender: UIButton!) {
        self.delegate?.userTappedAlarmSettings(surfAlarm)
    }
    
    @IBAction func alarmSwitchChanged(_ sender: UISwitch) {
        store.writeBlock {
            self.surfAlarm.isEnabledByUser = sender.isOn
        }
    }
}

protocol SurfAlarmTableViewCellDelegate: class {
    func userTappedAlarmSettings(_ alarm: SurfAlarm)
}
