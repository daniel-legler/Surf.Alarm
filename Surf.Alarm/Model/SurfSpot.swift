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
    
    var alarm: SurfAlarm? {
        return LinkingObjects(fromType: SurfAlarm.self, property: "surfSpot").first
    }
    
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
}

extension SurfSpot {
    
    var shouldRefresh: Bool {
        if let sixHoursAgo = Calendar.current.date(byAdding: .hour, value: -6, to: Date()) {
            return self.updatedAt < sixHoursAgo
        }
        return true
    }
    
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2DMake(latitude, longitude)
    }
}
