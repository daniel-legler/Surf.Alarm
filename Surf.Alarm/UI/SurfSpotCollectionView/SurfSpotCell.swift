import UIKit
import RealmSwift

class SurfSpotCollectionViewCell: DesignableCollectionViewCell {

    @IBOutlet weak var spotNameLabel: UILabel!
    @IBOutlet weak var countyLabel: UILabel!
    
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var windLabel: UILabel!
    @IBOutlet weak var tideLabel: UILabel!
    
    @IBOutlet weak var createAlarmButton: UIButton!
    
    @IBAction func createAlarmPressed(_ sender: UIButton!) {
        
    }

    var token: NotificationToken?
    var spot: SurfSpot!
    
    func configureCell(_ spot: SurfSpot) {
        self.spot = spot
        self.spotNameLabel.text = spot.name
        self.countyLabel.text = spot.county
        let forecast = store.currentSpotForecast(spot)
        self.updateForecast(forecast)
        self.token = spot.observe({ (change) in
            switch change {
            case .change(let properties):
                for property in properties where property.name == "updatedAt" {
                    let forecast = store.currentSpotForecast(spot)
                    DispatchQueue.main.async {
                        self.updateForecast(forecast)
                    }
                }
            case .error(let error):
                print("🌊Error: \(error.localizedDescription)")
            case .deleted:
                print("🌊Error: SurfSpot object was deleted")
            }
        })
    }
    
    func updateForecast(_ forecast: SurfForecast?) {
        if let forecast = forecast {
            self.heightLabel.text = forecast.waveHeight.toSurfRange()
            self.windLabel.text = forecast.windReport
            self.tideLabel.text = forecast.tideReport
        }
    }
    
}
