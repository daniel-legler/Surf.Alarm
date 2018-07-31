// Surf.Alarm

import UIKit
import UserNotifications

class NotificationAuthorizer {
    
    static var userIgnoredOpenAppSettingsForNotifications: Bool {
        get {
            return UserDefaults.standard.bool(forKey: Constants.userIgnoredOpenAppSettingsForNotifications)
        } set {
            UserDefaults.standard.set(newValue, forKey: Constants.userIgnoredOpenAppSettingsForNotifications)
        }
    }
    
    static func requestAuthorization() {
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        UNUserNotificationCenter.current().requestAuthorization(options: options) { (granted, error) in
            
        }

    }
    
    static func checkAuthorization(_ result: @escaping (Bool) -> Void) {
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            switch settings.authorizationStatus {
            case .authorized:
                result(true)
            case .denied:
                if userIgnoredOpenAppSettingsForNotifications {
                    result(true)
                } else {
                    result(false)
                }
            case .notDetermined:
                requestAuthorization()
            }
        }
    }
}

extension UIViewController {
    func checkNotificationAuthorizationStatus() {
        NotificationAuthorizer.checkAuthorization { (authorized) in
            if !authorized {
                DispatchQueue.main.async {
                    self.showAppSettingsDialog()
                }
            }
        }
    }
    
    func showAppSettingsDialog() {
        let dialog = UIAlertController(title: "Notifications Disabled",
                                       message: "Please enable them in app Settings to receive alarm notifications",
                                       preferredStyle: .alert)
        let settingsAction = UIAlertAction(title: "Settings", style: .default) { (action) in
            UIApplication.shared.open(URL(string: UIApplicationOpenSettingsURLString)!,
                                      options: [:],
                                      completionHandler: nil)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            NotificationAuthorizer.userIgnoredOpenAppSettingsForNotifications = true
        }
        dialog.addAction(cancelAction)
        dialog.addAction(settingsAction)
        self.present(dialog, animated: true, completion: nil)
    }
}
