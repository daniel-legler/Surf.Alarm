import Foundation
import RealmSwift
import SpitcastSwift

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
    
    func currentSpotForecast(spotId: Int) -> SurfForecast? {
        let forecastsForSpot = self.objects(SurfForecast.self).filter("spotId = %@", spotId)
        let futureForecasts = forecastsForSpot.filter("date > %@", Date())
        let sortedFutureForecasts = futureForecasts.sorted(byKeyPath: "date")
        return sortedFutureForecasts.first
    }
    
    func addSurfForecasts(_ forecasts: [SurfForecast]) {
        do {
            try write {
                self.add(forecasts, update: true)
            }
        } catch {
            print("🌊Error: \(error.localizedDescription)")
        }
    }
    
}

let store = try! Realm()
