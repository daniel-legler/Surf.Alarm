import Foundation
import RealmSwift
import SpitcastSwift
import MapKit

@objcMembers
class SurfSpot: Object {
    dynamic var spotId = 0
    dynamic var name: String = ""
    dynamic var county: String = ""
    dynamic var latitude: Double = 0.0
    dynamic var longitude: Double = 0.0

    override static func primaryKey() -> String? {
        return "spotId"
    }
    
    convenience init(_ spitcast: SCSurfSpot) {
        self.init()
        self.spotId = spitcast.spotId
        self.county = spitcast.county
        self.name = spitcast.name
        self.latitude = spitcast.latitude
        self.longitude = spitcast.longitude
    }
    
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2DMake(latitude, longitude)
    }
}

@objcMembers
class SurfForecast: Object {
    dynamic var date: Date = Date()
    dynamic var name: String = ""
    dynamic var latitude: Double = 0.0
    dynamic var longitude: Double = 0.0
    dynamic var spotId: Int = 0
    dynamic var waveHeight: Double = 0.0
    dynamic var swellReport: String = ""
    dynamic var tideReport: String = ""
    dynamic var windReport: String = ""
    
    convenience init(_ spitcast: SCForecast) {
        self.init()
        self.spotId = spitcast.spotId
        self.date = spitcast.date
        self.name = spitcast.name
        self.latitude = spitcast.latitude
        self.longitude = spitcast.longitude
        self.tideReport = spitcast.shapeDetails.tide
        self.windReport = spitcast.shapeDetails.wind
        self.swellReport = spitcast.shapeDetails.swell
        self.waveHeight = spitcast.size
    }
}

