// Surf.Alarm

import UIKit

extension UIView {
  func makeRound() {
    layer.cornerRadius = frame.size.width / 2.0
    layer.masksToBounds = true
  }

  func makeEndsRound() {
    layer.cornerRadius = bounds.height / 2.0
    layer.masksToBounds = true
  }
}
