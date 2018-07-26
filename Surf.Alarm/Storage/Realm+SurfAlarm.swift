import Foundation
import RealmSwift
import SpitcastSwift

let store = try! Realm()

extension Realm {
    
    // MARK: - SurfSpot
    
    var allSurfSpots: Results<SurfSpot> {
        return objects(SurfSpot.self)
    }
    
    func getSurfSpot(spotId: Int) -> SurfSpot? {
        return self.object(ofType: SurfSpot.self, forPrimaryKey: spotId)
    }
    
    func updateSurfSpots(_ spots: [SurfSpot]) {
        do {
            try write {
                self.add(spots, update: true)
            }
        } catch {
            print("🌊Error: \(error.localizedDescription)")
        }
    }
    
    // MARK: - SurfForecasts
    
    func shouldRefreshForecast(for spot: SurfSpot) -> Bool {
        if let twelveHoursAgo = Calendar.current.date(byAdding: .hour, value: -12, to: Date()) {
            return spot.updatedAt < twelveHoursAgo
        }
        return true
    }
    
    func currentSpotForecast(_ spot: SurfSpot) -> SurfForecast? {
        let futureForecasts = spot.forecasts.filter("date > %@", Date())
        let sortedFutureForecasts = futureForecasts.sorted(byKeyPath: "date")
        return sortedFutureForecasts.first
    }
    
    func addSurfForecasts(_ forecasts: [SurfForecast]) {
        do {
            try write {
                self.add(forecasts, update: true)
                forecasts.first?.surfSpot?.updatedAt = Date()
            }
        } catch {
            print("🌊Error: \(error.localizedDescription)")
        }
    }

//    func forecastWasUpdated(for spot: SurfSpot) {
//        do {
//            try write {
//                spot.updatedAt = Date()
//            }
//        } catch {
//            print("🌊Error: \(error.localizedDescription)")
//        }
//    }
    
}
