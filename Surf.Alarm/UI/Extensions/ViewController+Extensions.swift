// Surf.Alarm

import UIKit
extension UIViewController {
    
    func showBottomMessage(_ message: String, lengthOfTime time: Double) {
        let bottom = BottomMessage.withMessage(message)
        self.view.addSubview(bottom)
        NSLayoutConstraint.activate([
            bottom.leftAnchor.constraint(greaterThanOrEqualTo: self.view.leftAnchor, constant: 20),
            bottom.rightAnchor.constraint(lessThanOrEqualTo: self.view.rightAnchor, constant: -20),
            bottom.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -20),
            bottom.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0)
            ])
        
        DispatchQueue.main.asyncAfter(deadline: .now() + time) {
            UIView.animate(withDuration: 0.5, animations: {
                bottom.alpha = 0
            }, completion: { (_) in
                bottom.removeFromSuperview()
            })
        }
    }
        
    func showAppSettingsDialog(title: String) {
        let dialog = UIAlertController(title: title,
                                       message: "Please enable in the iOS Settings app",
                                       preferredStyle: .alert)
        let settingsAction = UIAlertAction(title: "Settings", style: .default) { (action) in
            UIApplication.shared.open(URL(string: UIApplicationOpenSettingsURLString)!,
                                      options: [:],
                                      completionHandler: nil)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            NotificationAuthorizer.userDisabledNotifications = true
        }
        dialog.addAction(cancelAction)
        dialog.addAction(settingsAction)
        self.present(dialog, animated: true, completion: nil)
    }

}