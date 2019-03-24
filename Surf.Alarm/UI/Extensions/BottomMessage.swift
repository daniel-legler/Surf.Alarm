// Surf.Alarm

import UIKit

class BottomMessage: DesignableView {
  @IBOutlet var messageLabel: UILabel!

  override func layoutSubviews() {
    super.layoutSubviews()
    makeEndsRound()
  }

  static func withMessage(_ message: String) -> BottomMessage {
    let bottom = R.nib.bottomMessage.firstView(owner: nil)!
    bottom.messageLabel.text = message
    bottom.translatesAutoresizingMaskIntoConstraints = false
    return bottom
  }
}
