// Surf.Alarm

import UIKit

class SurfHeightSelectorCell: UITableViewCell {

    @IBOutlet weak var heightSlider: UISlider!
    @IBOutlet weak var heightLabel: UILabel!
    weak var delegate: SurfHeightSliderDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    @IBAction func heightChanged(_ sender: UISlider) {
        if sender.value == 0 {
            self.delegate?.minimumHeightSelectionChanged(to: 0)
            heightLabel.text = "No Min"
        } else {
            let ftValue = Int((sender.value * 10).rounded())
            self.delegate?.minimumHeightSelectionChanged(to: ftValue)
            heightLabel.text = "\(ftValue)+ ft"
        }
    }
}

protocol SurfHeightSliderDelegate: class {
    func minimumHeightSelectionChanged(to newHeight: Int)
}
