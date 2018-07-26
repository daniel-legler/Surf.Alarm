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
    dynamic var updatedAt: Date = Date.distantPast
    
    let forecasts = LinkingObjects(fromType: SurfForecast.self, property: "surfSpot")
    
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
        self.updatedAt = Date()
    }
    
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2DMake(latitude, longitude)
    }
}
