// Surf.Alarm

import UIKit
import UserNotifications
import UserNotificationsUI

class NotificationViewController: UIViewController, UNNotificationContentExtension {
  @IBOutlet var spotLabel: UILabel?
  @IBOutlet var tideLabel: UILabel?
  @IBOutlet var windLabel: UILabel?
  @IBOutlet var surfLabel: UILabel?

  override func viewDidLoad() {
    super.viewDidLoad()
  }

  func didReceive(_ notification: UNNotification) {
    let userInfo = notification.request.content.userInfo
    guard
      let tide = userInfo["tideReport"] as? String,
      let wind = userInfo["windReport"] as? String,
      let surfHeight = userInfo["waveHeight"] as? Double,
      let spotName = userInfo["spotName"] as? String
    else {
      return
    }
    tideLabel?.text = tide
    windLabel?.text = wind
    surfLabel?.text = surfHeight.toSurfRange()
    spotLabel?.text = spotName
  }
}
