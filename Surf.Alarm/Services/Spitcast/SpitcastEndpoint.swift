import Foundation

enum SpitcastEndpoint: Endpoint {
    case all
    case forecast(spotId: Int)
    
    var baseUrl: URL {
        return URL(string: "http://api.spitcast.com/api/")!
    }

    func request() throws -> URLRequest {
        let requestUrl = try url()
        print(requestUrl.absoluteString)
        return try URLRequest(url: requestUrl, method: .get)
    }
    
    var path: String {
        switch self {
        case .all:
            return "spot/all"
        case .forecast(let spotId):
            return "spot/forecast/\(spotId)"
        }
    }
}


