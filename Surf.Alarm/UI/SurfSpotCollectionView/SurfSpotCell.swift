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
  @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
  
  @IBOutlet weak var createAlarmButton: AddAlarmButton!
  
  var spot: SurfSpot! {
    didSet {
      self.createAlarmButton.spot = spot
      self.spotNameLabel.text = spot.name
      self.countyLabel.text = spot.county
    }
  }
  
  var forecast: SurfForecast? {
    didSet {
      if let forecast = forecast {
        setForecast(forecast)
      } else {
        setUnavailable()
      }
    }
  }
  
  func setLoading() {
    loadingIndicator.startAnimating()
    loadingIndicator.isHidden = false
    statusLabel.text = "Loading..."
    statusContainer.backgroundColor = R.color.saAccent()
    resetSurfLabels()
    
  }
  
  private func setForecast(_ forecast: SurfForecast) {
    loadingIndicator.stopAnimating()
    statusLabel.text = "Updated \(spot.updatedAt.relativeToNow())"
    statusContainer.backgroundColor = R.color.saAccent()
    heightLabel.text = forecast.waveHeight.toSurfRange()
    windLabel.text = forecast.windReport
    tideLabel.text = forecast.tideReport
    
  }
  
  private func setUnavailable() {
    loadingIndicator.stopAnimating()
    resetSurfLabels()
    statusLabel.text = "Data Unavailable"
    statusContainer.backgroundColor = .red
  }
  
  private func resetSurfLabels() {
    heightLabel.text = "- - -"
    windLabel.text = "- - -"
    tideLabel.text = "- - -"
  }
}
