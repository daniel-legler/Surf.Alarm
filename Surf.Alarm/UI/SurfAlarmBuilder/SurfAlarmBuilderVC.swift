// Surf.Alarm

import UIKit
import Rswift

class SurfAlarmBuilderVC: UIViewController {
    
    @IBOutlet weak var spotNameLabel: UILabel!
    @IBOutlet weak var countyNameLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var surfSpot: SurfSpot!
    
    private struct Section {
        static let heightSelector = 0
        static let weekdays = 1
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.register(R.nib.surfHeightSelectorCell)
        self.spotNameLabel.text = surfSpot.name
        self.countyNameLabel.text = surfSpot.county
    }
    
    @IBAction func closeAlarmBuilder() {
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension SurfAlarmBuilderVC: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell?
        switch indexPath.section {
        case Section.heightSelector:
            cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.surfHeightSlider.identifier) ?? UITableViewCell()
        case Section.weekdays:
            cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.selectDaysCell.identifier)
        default:
            return UITableViewCell()
        }
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case Section.heightSelector:
            return "Minimum Surf Height"
        default:
            return nil
        }
    }
}

extension SurfAlarmBuilderVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case Section.weekdays:
            self.performSegue(withIdentifier: R.segue.surfAlarmBuilderVC.showDaysOfWeek, sender: nil)
        default:
            break
        }
    }
    
}
