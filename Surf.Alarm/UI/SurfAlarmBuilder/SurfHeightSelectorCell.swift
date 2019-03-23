// Surf.Alarm

import UIKit

class SurfHeightSelectorCell: UITableViewCell {

  @IBOutlet weak var heightSlider: UISlider!
  @IBOutlet weak var heightLabel: UILabel!
  weak var delegate: SurfHeightSliderDelegate?

  @IBAction func heightChanged(_ sender: UISlider) {
    let intValue = Int((sender.value * 10).rounded())
    self.delegate?.minimumHeightSelectionChanged(to: intValue)
    self.updateHeightLabel(intValue)
  }

  func configure(with alarm: SurfAlarm) {
    self.updateHeightLabel(alarm.minHeight)
    self.heightSlider.value = Float(alarm.minHeight) / 10.0
  }

  private func updateHeightLabel(_ value: Int) {
    if value == 0 {
      heightLabel.text = "No Min"
    } else {
      heightLabel.text = "\(value)+ ft"
    }
  }
}

protocol SurfHeightSliderDelegate: class {
  func minimumHeightSelectionChanged(to newHeight: Int)
}
