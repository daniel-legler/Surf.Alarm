// Surf.Alarm

import UIKit

extension UIView {
  func makeRound() {
    self.layer.cornerRadius = self.frame.size.width / 2.0
    self.layer.masksToBounds = true
  }

  func makeEndsRound() {
    self.layer.cornerRadius = self.bounds.height / 2.0
    self.layer.masksToBounds = true
  }
}
