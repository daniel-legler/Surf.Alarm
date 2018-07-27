// Surf.Alarm

import UIKit

class SurfHeightSelectorCell: UITableViewCell {

    @IBOutlet weak var heightSlider: UISlider!
    @IBOutlet weak var heightLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    @IBAction func heightChanged(_ sender: UISlider) {
        if sender.value == 0 {
            heightLabel.text = "No Min"
        } else {
            let ftValue = Int((sender.value * 10).rounded())
            heightLabel.text = "\(ftValue)+ ft"
        }
    }
}
