// Surf.Alarm

import UIKit

class BottomMessage: DesignableView {
  
  @IBOutlet weak var messageLabel: UILabel!
  
  override func layoutSubviews() {
    super.layoutSubviews()
    self.makeEndsRound()
  }
  
  static func withMessage(_ message: String) -> BottomMessage {
    let bottom = R.nib.bottomMessage.firstView(owner: nil)!
    bottom.messageLabel.text = message
    bottom.translatesAutoresizingMaskIntoConstraints = false
    return bottom
  }
}
