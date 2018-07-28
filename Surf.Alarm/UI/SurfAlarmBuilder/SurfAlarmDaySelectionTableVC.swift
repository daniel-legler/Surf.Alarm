// Surf.Alarm

import UIKit

class SurfAlarmDaySelectionTableVC: UITableViewController {

    weak var delegate: SurfAlarmDaySelectionDelegate?
    
    var weekdays: [String] {
        return Calendar.current.weekdaySymbols
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = R.color.surfTintPrimary()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        
        if cell.accessoryType == .checkmark {
            self.delegate?.disabledDay(weekdays[indexPath.row])
        } else if cell.accessoryType == .none {
            self.delegate?.enabledDay(weekdays[indexPath.row])
        }
        cell.accessoryType = cell.accessoryType == .none ? .checkmark : .none
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

protocol SurfAlarmDaySelectionDelegate: class {
    func disabledDay(_ day: String)
    func enabledDay(_ day: String)
}
