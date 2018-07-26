import UIKit

class SurfSpotCollectionViewCell: DesignableCollectionViewCell {
    @IBOutlet weak var spotNameLabel: UILabel!
    @IBOutlet weak var countyLabel: UILabel!
    
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var windLabel: UILabel!
    @IBOutlet weak var tideLabel: UILabel!
    
    @IBOutlet weak var createAlarmButton: UIButton!
    
    @IBAction func createAlarmPressed(_ sender: UIButton!) {
        
    }

    func configureCell(_ forecast: SurfForecast) {
        self.spotNameLabel.text = forecast.name
        
        self.heightLabel.text = forecast.waveHeight.toSurfRange()
        self.windLabel.text = forecast.windReport
        self.tideLabel.text = forecast.tideReport
    }
    
    func configureUI() {
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 6.0

        self.createAlarmButton.layer.masksToBounds = true
        self.createAlarmButton.layer.cornerRadius = 6.0
    }
}
