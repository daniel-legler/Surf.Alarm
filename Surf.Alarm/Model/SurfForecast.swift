// Surf.Alarm

import Foundation
import RealmSwift
import SpitcastSwift

@objcMembers
class SurfForecast: Object {
  dynamic var date: Date = Date()
  dynamic var waveHeight: Double = 0.0
  dynamic var swellReport: String = ""
  dynamic var tideReport: String = ""
  dynamic var windReport: String = ""

  dynamic var surfSpot: SurfSpot?

  convenience init(spot: SurfSpot, _ spitcast: SCForecast) {
    self.init()
    date = spitcast.date
    tideReport = spitcast.shapeDetails.tide
    windReport = spitcast.shapeDetails.wind
    swellReport = spitcast.shapeDetails.swell
    waveHeight = spitcast.size
    surfSpot = spot
  }
}
