// Surf.Alarm

import UIKit
import Rswift

class SurfAlarmBuilderVC: UIViewController {
    
    @IBOutlet weak var spotNameLabel: UILabel!
    @IBOutlet weak var countyNameLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var timePicker: UIDatePicker!
    
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
        self.spotNameLabel.text = surfSpot?.name ?? alarm.surfSpot?.name
        self.countyNameLabel.text = surfSpot?.county ?? alarm.surfSpot?.county
        self.timePicker.setDate(alarm.pickerDate, animated: false)
        updateEnabledDaysLabel()
    }
    
    private func setupTableView() {
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.register(R.nib.surfHeightSelectorCell)
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
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveAlarmPressed() {
        store.saveAlarm(self.alarm)
        self.dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let daySelector = segue.destination as? SurfAlarmDaySelectionTableVC {
            daySelector.delegate = self
            daySelector.initialDisabledDays = Array(self.alarm.disabledDays)
        }
    }
}

extension SurfAlarmBuilderVC: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = Section(rawValue: indexPath.section) else { return UITableViewCell() }
        switch section {
        case .heightSelector:
            let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.surfHeightSlider.identifier) as? SurfHeightSelectorCell ?? SurfHeightSelectorCell()
            cell.delegate = self
            cell.configure(with: alarm)
            return cell
        case .weekdays:
            let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.selectDaysCell.identifier) ?? UITableViewCell()
            cell.detailTextLabel?.text = Date.alarmString(disabledWeekdays: Array(self.alarm.disabledDays))
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
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
            self.performSegue(withIdentifier: R.segue.surfAlarmBuilderVC.showDaysOfWeek, sender: nil)
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
            daysCell.detailTextLabel?.text = Date.alarmString(disabledWeekdays: Array(self.alarm.disabledDays))
            tableView.reloadData()
        }
    }
}
