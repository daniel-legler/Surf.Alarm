import Foundation

struct SpitcastSpot: Codable {
    var latitude: Double
    var longitude: Double
    var name: String
    var spotId: Int
    
    private enum CodingKeys: String, CodingKey {
        case spotId = "spot_id"
        case name = "spot_name"
        case latitude
        case longitude
    }
}

struct SpitcastForecast: Codable {
    var date: Date
    var shape: String
    var shapeDetails: SpitcastShape
    var size: Double
    var spotId: Int
    var name: String
    
    private enum CodingKeys: String, CodingKey {
        case date
        case shape = "shape_full"
        case shapeDetails = "shape_detail"
        case size = "size_ft"
        case spotId = "spot_id"
        case name = "spot_name"
    }
}

struct SpitcastShape: Codable {
    var swell: String
    var tide: String
    var wind: String
}

/*
 {
     "date":"Thursday Jul 12 2018",
     "day":"Thu",
     "gmt":"2018-7-12 7",
     "hour":"12AM",
     "latitude":36.954087622045307,
     "live":1,
     "longitude":-121.9716900628907,
     "shape":"f",
     "shape_detail":{   "swell":"Poor-Fair",
                        "tide":"Fair",
                        "wind":"Fair"
                    },
     "shape_full":"Fair",
     "size":2,
     "size_ft":2.4611236162341488,
     "spot_id":1,
     "spot_name":"Pleasure Point",
     "warnings":[]
 }
 */
