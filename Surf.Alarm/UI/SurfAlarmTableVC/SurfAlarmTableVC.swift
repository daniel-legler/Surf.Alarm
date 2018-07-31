// Surf.Alarm

import UIKit
import Rswift
class SurfAlarmTableVC: UIViewController {

    @IBOutlet weak var emptyAlarmsImage: UIImageView!
    
    @IBOutlet weak var tableView: UITableView!
    let alarms = store.allAlarms().sorted(byKeyPath: "spotName")
    weak var delegate: SurfAlarmTableViewDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        emptyAlarmsImage.makeRound()
    }
    
    @IBAction func closeButtonTapped(_ sender: UIButton!) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension SurfAlarmTableVC: SurfAlarmTableViewCellDelegate {
    func userTappedAlarmSettings(_ alarm: SurfAlarm) {
        guard
            let alarmBuilderNav = R.storyboard.surfAlarmBuilder.instantiateInitialViewController(),
            let alarmBuilder = alarmBuilderNav.topViewController as? SurfAlarmBuilderVC
        else {
            return
        }
        
        alarmBuilder.alarm = alarm
        self.present(alarmBuilderNav, animated: true, completion: nil)
    }
}

extension SurfAlarmTableVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return alarms.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .clear
        return headerView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.surfAlarmDetailCell, for: indexPath) {
            cell.surfAlarm = alarms[indexPath.section]
            cell.delegate = self
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        return UISwipeActionsConfiguration.deleteConfiguration({ (action, view, handler) in
            store.deleteAlarm(self.alarms[indexPath.section])
            let indexSet = IndexSet(arrayLiteral: indexPath.section)
            self.tableView.deleteSections(indexSet, with: .automatic)
            self.tableView.reloadData()
        })
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        return UISwipeActionsConfiguration.viewMapConfiguration({ (action, view, handler) in
            self.navigationController?.dismiss(animated: true, completion: nil)
            self.delegate?.userTappedViewMap(for: self.alarms[indexPath.section])
        })
    }
}

protocol SurfAlarmTableViewDelegate: class {
    func userTappedViewMap(for alarm: SurfAlarm)
}
