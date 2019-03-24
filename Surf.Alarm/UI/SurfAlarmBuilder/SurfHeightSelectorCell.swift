// Surf.Alarm

import UIKit

class SurfHeightSelectorCell: UITableViewCell {
  @IBOutlet var heightSlider: UISlider!
  @IBOutlet var heightLabel: UILabel!
  weak var delegate: SurfHeightSliderDelegate?

  @IBAction func heightChanged(_ sender: UISlider) {
    let intValue = Int((sender.value * 10).rounded())
    delegate?.minimumHeightSelectionChanged(to: intValue)
    updateHeightLabel(intValue)
  }

  func configure(with alarm: SurfAlarm) {
    updateHeightLabel(alarm.minHeight)
    heightSlider.value = Float(alarm.minHeight) / 10.0
  }

  private func updateHeightLabel(_ value: Int) {
    if value == 0 {
      heightLabel.text = "No Min"
    } else {
      heightLabel.text = "\(value)+ ft"
    }
  }
}

protocol SurfHeightSliderDelegate: AnyObject {
  func minimumHeightSelectionChanged(to newHeight: Int)
}
