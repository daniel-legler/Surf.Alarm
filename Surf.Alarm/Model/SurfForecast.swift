// Surf.Alarm

import Foundation
import RealmSwift
import SpitcastSwift

@objcMembers
class SurfForecast: Object {
    dynamic var date: Date = Date()
    dynamic var spotName: String = ""
    dynamic var latitude: Double = 0.0
    dynamic var longitude: Double = 0.0
    dynamic var spotId: Int = 0
    dynamic var waveHeight: Double = 0.0
    dynamic var swellReport: String = ""
    dynamic var tideReport: String = ""
    dynamic var windReport: String = ""
    dynamic var surfSpot: SurfSpot?
    
    convenience init(_ spitcast: SCForecast) {
        self.init()
        self.spotId = spitcast.spotId
        self.date = spitcast.date
        self.spotName = spitcast.name
        self.latitude = spitcast.latitude
        self.longitude = spitcast.longitude
        self.tideReport = spitcast.shapeDetails.tide
        self.windReport = spitcast.shapeDetails.wind
        self.swellReport = spitcast.shapeDetails.swell
        self.waveHeight = spitcast.size
    }
}
