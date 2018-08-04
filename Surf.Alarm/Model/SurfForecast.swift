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
        self.date = spitcast.date
        self.tideReport = spitcast.shapeDetails.tide
        self.windReport = spitcast.shapeDetails.wind
        self.swellReport = spitcast.shapeDetails.swell
        self.waveHeight = spitcast.size
        self.surfSpot = spot
    }
}
