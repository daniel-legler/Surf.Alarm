// Surf.Alarm

import UIKit

class SurfAlarmDaySelectionTableVC: UITableViewController {
  var initialDisabledDays: [String] = []
  weak var delegate: SurfAlarmDaySelectionDelegate?

  private let weekdays: [String] = Calendar.current.weekdaySymbols

  override func viewDidLoad() {
    super.viewDidLoad()
    navigationController?.navigationBar.tintColor = R.color.saPrimaryDark()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    setInitialCheckMarks()
  }

  private func setInitialCheckMarks() {
    for day in initialDisabledDays {
      guard
        let dayIndex = weekdays.index(of: day),
        let cell = tableView.cellForRow(at: IndexPath(row: dayIndex, section: 0))
      else {
        return
      }
      cell.accessoryType = .none
    }
  }

  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard let cell = tableView.cellForRow(at: indexPath) else { return }

    if cell.accessoryType == .checkmark {
      delegate?.disabledDay(weekdays[indexPath.row])
    } else if cell.accessoryType == .none {
      delegate?.enabledDay(weekdays[indexPath.row])
    }
    cell.accessoryType = cell.accessoryType == .none ? .checkmark : .none
    tableView.deselectRow(at: indexPath, animated: true)
  }
}

protocol SurfAlarmDaySelectionDelegate: AnyObject {
  func disabledDay(_ day: String)
  func enabledDay(_ day: String)
}
