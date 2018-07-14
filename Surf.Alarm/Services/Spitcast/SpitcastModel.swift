import Foundation

struct SpitcastSpot: Codable {
    var spotId: Int
    var name: String
    var county: String
    var latitude: Double
    var longitude: Double
    
    private enum CodingKeys: String, CodingKey {
        case county = "county_name"
        case latitude
        case longitude
        case spotId = "spot_id"
        case name = "spot_name"
    }
}

struct SpitcastForecast: Codable {
    
    struct SpitcastShape: Codable {
        var swell: String
        var tide: String
        var wind: String
    }
    
    var latitude: Double
    var longitude: Double
    var date: Date
    var shape: String
    var shapeDetails: SpitcastShape
    var size: Double
    var spotId: Int
    var name: String
    
    private enum CodingKeys: String, CodingKey {
        case date = "gmt"
        case shape = "shape_full"
        case shapeDetails = "shape_detail"
        case size = "size_ft"
        case spotId = "spot_id"
        case name = "spot_name"
        case latitude
        case longitude
    }
}
