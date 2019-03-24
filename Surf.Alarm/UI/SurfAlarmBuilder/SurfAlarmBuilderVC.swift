// Surf.Alarm

import Rswift
import UIKit

class SurfAlarmBuilderVC: UIViewController {
  @IBOutlet var spotNameLabel: UILabel!
  @IBOutlet var countyNameLabel: UILabel!
  @IBOutlet var tableView: UITableView!
  @IBOutlet var timePicker: UIDatePicker!

  var surfSpot: SurfSpot!
  var alarm: SurfAlarm!

  enum Section: Int {
    case heightSelector = 0
    case weekdays = 1
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    setupTableView()
    setupInitialUI()
  }

  private func setupInitialUI() {
    spotNameLabel.text = surfSpot?.name ?? alarm.surfSpot?.name
    countyNameLabel.text = surfSpot?.county ?? alarm.surfSpot?.county
    timePicker.setDate(alarm.pickerDate, animated: false)
    updateEnabledDaysLabel()
  }

  private func setupTableView() {
    tableView.dataSource = self
    tableView.delegate = self
    tableView.register(R.nib.surfHeightSelectorCell)
  }

  func configure(with spot: SurfSpot) {
    surfSpot = spot
    alarm = SurfAlarm(spot: spot)
  }

  @IBAction func timeChanged(_ sender: UIDatePicker) {
    let hour = sender.calendar.component(.hour, from: sender.date)
    let minute = sender.calendar.component(.minute, from: sender.date)
    store.writeBlock {
      alarm.hour = hour
      alarm.minute = minute
    }
  }

  @IBAction func cancelButtonPressed() {
    dismiss(animated: true, completion: nil)
  }

  @IBAction func saveAlarmPressed() {
    store.saveAlarm(alarm)
    dismiss(animated: true, completion: nil)
  }

  override func prepare(for segue: UIStoryboardSegue, sender _: Any?) {
    if let daySelector = segue.destination as? SurfAlarmDaySelectionTableVC {
      daySelector.delegate = self
      daySelector.initialDisabledDays = Array(alarm.disabledDays)
    }
  }
}

extension SurfAlarmBuilderVC: UITableViewDataSource, UITableViewDelegate {
  func numberOfSections(in _: UITableView) -> Int {
    return 2
  }

  func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
    return 1
  }

  func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
    return 44
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let section = Section(rawValue: indexPath.section) else { return UITableViewCell() }
    switch section {
    case .heightSelector:
      let reuseId = R.reuseIdentifier.surfHeightSlider.identifier
      let dequeuedCell = tableView.dequeueReusableCell(withIdentifier: reuseId)
      let cell = dequeuedCell as? SurfHeightSelectorCell ?? SurfHeightSelectorCell()
      cell.delegate = self
      cell.configure(with: alarm)
      return cell
    case .weekdays:
      let reuseId = R.reuseIdentifier.selectDaysCell.identifier
      let cell = tableView.dequeueReusableCell(withIdentifier: reuseId) ?? UITableViewCell()
      cell.detailTextLabel?.text = Date.alarmString(disabledWeekdays: Array(alarm.disabledDays))
      return cell
    }
  }

  func tableView(_: UITableView, titleForHeaderInSection section: Int) -> String? {
    guard let section = Section(rawValue: section) else { return nil }
    switch section {
    case .heightSelector:
      return "Minimum Surf Height"
    default:
      return nil
    }
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard let section = Section(rawValue: indexPath.section) else { return }
    switch section {
    case .weekdays:
      performSegue(withIdentifier: R.segue.surfAlarmBuilderVC.showDaysOfWeek, sender: nil)
      tableView.deselectRow(at: indexPath, animated: true)
    default:
      break
    }
  }
}

extension SurfAlarmBuilderVC: SurfHeightSliderDelegate, SurfAlarmDaySelectionDelegate {
  func minimumHeightSelectionChanged(to newHeight: Int) {
    store.writeBlock {
      self.alarm.minHeight = newHeight
    }
  }

  func enabledDay(_ day: String) {
    if let index = self.alarm.disabledDays.index(of: day) {
      store.writeBlock {
        self.alarm.disabledDays.remove(at: index)
        self.updateEnabledDaysLabel()
      }
    }
  }

  func disabledDay(_ day: String) {
    store.writeBlock {
      self.alarm.disabledDays.append(day)
      self.updateEnabledDaysLabel()
    }
  }

  func updateEnabledDaysLabel() {
    let indexPath = IndexPath(row: 0, section: Section.weekdays.rawValue)
    if let daysCell = self.tableView.cellForRow(at: indexPath) {
      daysCell.detailTextLabel?.text = Date.alarmString(disabledWeekdays: Array(alarm.disabledDays))
      tableView.reloadData()
    }
  }
}
