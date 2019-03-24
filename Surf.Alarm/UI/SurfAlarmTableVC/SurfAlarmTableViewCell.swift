// Surf.Alarm

import UIKit

class SurfAlarmTableViewCell: UITableViewCell {
  @IBOutlet var spotLabel: UILabel!
  @IBOutlet var countyLabel: UILabel!
  @IBOutlet var surfHeightLabel: UILabel!
  @IBOutlet var calendarDays: UILabel!
  @IBOutlet var timeLabel: UILabel!
  @IBOutlet var enabledSwitch: UISwitch!

  weak var delegate: SurfAlarmTableViewCellDelegate?

  var surfAlarm: SurfAlarm! {
    didSet {
      spotLabel.text = surfAlarm.surfSpot?.name
      countyLabel.text = surfAlarm.surfSpot?.county
      surfHeightLabel.text = "\(surfAlarm.minHeight)+ ft"
      timeLabel.text = Date.alarmString(hour: surfAlarm.hour,
                                        minute: surfAlarm.minute)
      calendarDays.text = Date.alarmString(disabledWeekdays: Array(surfAlarm.disabledDays))
      enabledSwitch.isOn = surfAlarm.isEnabledByUser
    }
  }

  @IBAction func settingsTapped(_: UIButton!) {
    delegate?.userTappedAlarmSettings(surfAlarm)
  }

  @IBAction func alarmSwitchChanged(_ sender: UISwitch) {
    if !sender.isOn {
      NotificationScheduler.cancel(surfAlarm)
    }

    store.writeBlock {
      self.surfAlarm.isEnabledByUser = sender.isOn
    }
  }
}

protocol SurfAlarmTableViewCellDelegate: AnyObject {
  func userTappedAlarmSettings(_ alarm: SurfAlarm)
}
