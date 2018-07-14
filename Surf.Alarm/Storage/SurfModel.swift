import Foundation
import RealmSwift

class SurfSpot: Object {
    @objc dynamic var spotId = 0
    @objc dynamic var name: String = ""
    @objc dynamic var county: String = ""
    @objc dynamic var latitude: Double = 0.0
    @objc dynamic var longitude: Double = 0.0
    let reports = LinkingObjects(fromType: SurfForecast.self, property: "spot")

    override static func primaryKey() -> String? {
        return "spotId"
    }
    
    convenience init(_ spitcast: SpitcastSpot) {
        self.init()
        self.spotId = spitcast.spotId
        self.county = spitcast.county
        self.name = spitcast.name
        self.latitude = spitcast.latitude
        self.longitude = spitcast.longitude
    }
}

class SurfForecast: Object {
    @objc dynamic var date: Date = Date()
    @objc dynamic var name: String = ""
    @objc dynamic var latitude: Double = 0.0
    @objc dynamic var longitude: Double = 0.0
    @objc dynamic var spot: SurfSpot?
}

