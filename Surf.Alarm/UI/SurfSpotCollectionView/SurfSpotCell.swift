import RealmSwift
import UIKit

class SurfSpotCollectionViewCell: DesignableCollectionViewCell {
  @IBOutlet var spotNameLabel: UILabel!
  @IBOutlet var countyLabel: UILabel!

  @IBOutlet var heightLabel: UILabel!
  @IBOutlet var windLabel: UILabel!
  @IBOutlet var tideLabel: UILabel!

  @IBOutlet var statusLabel: UILabel!
  @IBOutlet var statusContainer: DesignableView!
  @IBOutlet var loadingIndicator: UIActivityIndicatorView!

  @IBOutlet var createAlarmButton: AddAlarmButton!

  var spot: SurfSpot! {
    didSet {
      createAlarmButton.spot = spot
      spotNameLabel.text = spot.name
      countyLabel.text = spot.county
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
