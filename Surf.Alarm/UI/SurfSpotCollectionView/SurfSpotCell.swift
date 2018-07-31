import UIKit
import RealmSwift

class SurfSpotCollectionViewCell: DesignableCollectionViewCell {

    @IBOutlet weak var spotNameLabel: UILabel!
    @IBOutlet weak var countyLabel: UILabel!
    
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var windLabel: UILabel!
    @IBOutlet weak var tideLabel: UILabel!
    
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var statusContainer: DesignableView!
    
    @IBOutlet weak var createAlarmButton: AddAlarmButton!
    
    var spot: SurfSpot!
    
    func configure(_ spot: SurfSpot) {
        self.spot = spot
        self.createAlarmButton.spot = spot
        self.spotNameLabel.text = spot.name
        self.countyLabel.text = spot.county
    }
    
    func updateForecast(_ forecast: SurfForecast?) {
        if let forecast = forecast {
            self.heightLabel.text = forecast.waveHeight.toSurfRange()
            self.windLabel.text = forecast.windReport
            self.tideLabel.text = forecast.tideReport
            self.statusLabel.text = "Updated \(spot.updatedAt.relativeToNow())"
            self.statusContainer.backgroundColor = R.color.saAccent()
        } else {
            self.statusLabel.text = "Data Unavailable"
            self.statusContainer.backgroundColor = .red
        }
    }
    
}
