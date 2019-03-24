// Surf.Alarm

import UIKit
extension UIViewController {
  func showBottomMessage(_ message: String, lengthOfTime time: Double) {
    let bottom = BottomMessage.withMessage(message)
    view.addSubview(bottom)
    NSLayoutConstraint.activate([
      bottom.leftAnchor.constraint(greaterThanOrEqualTo: view.leftAnchor, constant: 20),
      bottom.rightAnchor.constraint(lessThanOrEqualTo: view.rightAnchor, constant: -20),
      bottom.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
      bottom.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor, constant: 0),
    ])

    DispatchQueue.main.asyncAfter(deadline: .now() + time) {
      UIView.animate(withDuration: 0.5, animations: {
        bottom.alpha = 0
      }, completion: { _ in
        bottom.removeFromSuperview()
      })
    }
  }

  func showAppSettingsDialog(title: String) {
    let dialog = UIAlertController(title: title,
                                   message: "Please enable in the iOS Settings app",
                                   preferredStyle: .alert)
    let settingsAction = UIAlertAction(title: "Settings", style: .default) { _ in
      UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!,
                                options: [:],
                                completionHandler: nil)
    }
    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
      NotificationAuthorizer.userDisabledNotifications = true
    }
    dialog.addAction(cancelAction)
    dialog.addAction(settingsAction)
    present(dialog, animated: true, completion: nil)
  }
}
