import Foundation
import RealmSwift

//enum County: String {
//    case delNorte = "Del Norte"
//    case humboldt = "Humboldt"
//    case sonoma = "Sonoma"
//    case marin = "Marin"
//    case sanFrancisco = "San Francisco"
//    case sanMateo = "San Mateo"
//    case santaCruz = "Santa Cruz"
//    case monterey = "Monterey"
//    case sanLuisObispo = "San Luis Obispo"
//    case santaBarbara = "Santa Barbara"
//    case ventura = "Ventura"
//    case losAngeles = "Los Angeles"
//    case orangeCounty = "Orange County"
//    case sanDiego = "San Diego"
//
//    var name: String {
//        return self.rawValue
//    }
//}

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

