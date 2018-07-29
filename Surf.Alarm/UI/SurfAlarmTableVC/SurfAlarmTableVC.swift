// Surf.Alarm

import UIKit
import Rswift
class SurfAlarmTableVC: UIViewController {

    let alarms = store.allAlarms().sorted(byKeyPath: "spotName")
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
}
extension SurfAlarmTableVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 152
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return alarms.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.surfAlarmDetailCell, for: indexPath) {
            cell.surfAlarm = alarms[indexPath.row]
            return cell
        }
        return UITableViewCell()
    }
}
