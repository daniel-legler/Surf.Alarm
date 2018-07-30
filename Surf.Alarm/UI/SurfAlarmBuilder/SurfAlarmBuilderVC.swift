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
    
    private struct Section {
        static let heightSelector = 0
        static let weekdays = 1
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.register(R.nib.surfHeightSelectorCell)
        
        self.spotNameLabel.text = surfSpot?.name ?? alarm.spotName
        self.countyNameLabel.text = surfSpot?.county ?? alarm.county
        
        self.updateEnabledDaysLabel()
        self.timePicker.setDate(alarm.date, animated: false)
    }
    
    func configure(with spot: SurfSpot) {
        surfSpot = spot
        alarm = SurfAlarm()
        alarm.county = surfSpot.county
        alarm.spotId = surfSpot.spotId
        alarm.spotName = surfSpot.name
        alarm.latitude = surfSpot.latitude
        alarm.longitude = surfSpot.longitude
    }
        
    @IBAction func timeChanged(_ sender: UIDatePicker) {
        self.alarm.alarmHour = sender.calendar.component(.hour, from: sender.date)
        self.alarm.alarmMinute = sender.calendar.component(.minute, from: sender.date)
    }
    
    @IBAction func closeAlarmBuilder() {
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case Section.heightSelector:
            let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.surfHeightSlider.identifier) as? SurfHeightSelectorCell ?? SurfHeightSelectorCell()
            cell.delegate = self
            cell.configure(with: alarm)
            return cell
        case Section.weekdays:
            let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.selectDaysCell.identifier) ?? UITableViewCell()
            cell.detailTextLabel?.text = Date.alarmString(disabledWeekdays: Array(self.alarm.disabledDays))
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case Section.heightSelector:
            return "Minimum Surf Height"
        default:
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case Section.weekdays:
            self.performSegue(withIdentifier: R.segue.surfAlarmBuilderVC.showDaysOfWeek, sender: nil)
            tableView.deselectRow(at: indexPath, animated: true)
        default:
            break
        }
    }
}

extension SurfAlarmBuilderVC: SurfHeightSliderDelegate, SurfAlarmDaySelectionDelegate {
    func minimumHeightSelectionChanged(to newHeight: Int) {
        self.alarm.minHeight = newHeight
    }
    
    func enabledDay(_ day: String) {
        if let index = self.alarm.disabledDays.index(of: day) {
            self.alarm.disabledDays.remove(at: index)
            self.updateEnabledDaysLabel()
        }
    }
    
    func disabledDay(_ day: String) {
        self.alarm.disabledDays.append(day)
        self.updateEnabledDaysLabel()
    }
    
    func updateEnabledDaysLabel() {
        let indexPath = IndexPath(row: 0, section: Section.weekdays)
        if let daysCell = self.tableView.cellForRow(at: indexPath) {
            daysCell.detailTextLabel?.text = Date.alarmString(disabledWeekdays: Array(self.alarm.disabledDays))
            tableView.reloadData()
        }
    }
}
