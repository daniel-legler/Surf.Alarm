import Foundation
import Alamofire

class SpitcastClient {
    
    static func allSpots(_ completion: @escaping (Result<[SpitcastSpot]>) -> Void) {
        
        let endpoint = SpitcastEndpoint.all
        do {
            let request = try endpoint.request()
            Alamofire.request(request)
                .validate()
                .response(responseSerializer: DataRequest.allSpotsSerializer()) { (dataResponse) in
                    completion(dataResponse.result)
            }
        } catch {
            completion(.failure(error))
        }
    }
    
    static func forecast(spotId: Int, _ completion: @escaping (Result<[SpitcastForecast]>) -> Void) {
        
        let endpoint = SpitcastEndpoint.forecast(spotId: spotId)
        
        do {
            let request = try endpoint.request()
            Alamofire.request(request)
                .validate()
                .response(responseSerializer: DataRequest.forecastSerializer()) { (dataResponse) in
                    completion(dataResponse.result)
            }
        } catch {
            completion(.failure(error))
        }
    }
}

extension DataRequest {
    static func allSpotsSerializer() -> DataResponseSerializer<[SpitcastSpot]> {
        return DataResponseSerializer { (_, _, data, error) -> Result<[SpitcastSpot]> in
            guard let data = data else {
                return .failure(AFError.responseSerializationFailed(reason: .inputDataNil))
            }
            
            do {
                let spots = try JSONDecoder().decode([SpitcastSpot].self, from: data)
                return .success(spots)
            } catch {
                return .failure(AFError.responseSerializationFailed(reason: .jsonSerializationFailed(error: error)))
            }
        }
    }
    
    static func forecastSerializer() -> DataResponseSerializer<[SpitcastForecast]> {
        return DataResponseSerializer { (_, _, data, error) -> Result<[SpitcastForecast]> in
            guard let data = data else {
                return .failure(AFError.responseSerializationFailed(reason: .inputDataNil))
            }
            
            do {
                let decoder = JSONDecoder()
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-M-d H"
                dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
                decoder.dateDecodingStrategy = .formatted(dateFormatter)
                let forecasts = try decoder.decode([SpitcastForecast].self, from: data)
                return .success(forecasts)
            } catch {
                return .failure(AFError.responseSerializationFailed(reason: .jsonSerializationFailed(error: error)))
            }
        }
    }
}
