// Surf.Alarm

import Rswift
import UIKit
class SurfAlarmTableVC: UIViewController {
  @IBOutlet var emptyAlarmsImage: UIImageView!
  @IBOutlet var tableView: UITableView!

  let alarms = store.allAlarms.sorted(byKeyPath: "hour")
  weak var delegate: SurfAlarmTableViewDelegate?

  override func viewDidLoad() {
    super.viewDidLoad()
    setupTableView()
    checkNotificationAuthorization()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    emptyAlarmsImage.makeRound()
    tableView.reloadData()
  }

  @IBAction func closeButtonTapped(_: Any!) {
    dismiss(animated: true, completion: nil)
  }

  private func setupTableView() {
    tableView.delegate = self
    tableView.dataSource = self
    tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    tableView.isHidden = alarms.isEmpty
  }

  private func checkNotificationAuthorization() {
    NotificationAuthorizer.checkAuthorization { granted in
      if !granted, NotificationAuthorizer.userDisabledNotifications {
        DispatchQueue.main.async {
          self.showBottomMessage("Enable Notifications in iOS Settings to set alarms", lengthOfTime: 4.0)
        }
      }
    }
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
    present(alarmBuilderNav, animated: true, completion: nil)
  }
}

extension SurfAlarmTableVC: UITableViewDelegate, UITableViewDataSource {
  func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
    return 150
  }

  func numberOfSections(in _: UITableView) -> Int {
    return alarms.count
  }

  func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
    return 1
  }

  func tableView(_: UITableView, heightForHeaderInSection _: Int) -> CGFloat {
    return 10
  }

  func tableView(_: UITableView, viewForHeaderInSection _: Int) -> UIView? {
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

  func tableView(_: UITableView, canEditRowAt _: IndexPath) -> Bool {
    return true
  }

  func tableView(_: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    return UISwipeActionsConfiguration.deleteConfiguration { _, _, _ in
      NotificationScheduler.cancel(self.alarms[indexPath.section])
      store.deleteAlarm(self.alarms[indexPath.section])
      let indexSet = IndexSet(arrayLiteral: indexPath.section)
      self.tableView.deleteSections(indexSet, with: .automatic)
      self.tableView.reloadData()
      self.tableView.isHidden = self.alarms.isEmpty
    }
  }

  func tableView(_: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    return UISwipeActionsConfiguration.viewMapConfiguration { _, _, _ in
      self.dismiss(animated: true, completion: nil)
      self.delegate?.userTappedViewMap(for: self.alarms[indexPath.section])
    }
  }
}

protocol SurfAlarmTableViewDelegate: AnyObject {
  func userTappedViewMap(for alarm: SurfAlarm)
}
