import Foundation
import RealmSwift
import SpitcastSwift

let store = try! Realm()

extension Realm {
    
    func writeBlock(_ block: () -> Void) {
        do {
            try write {
                block()
            }
        } catch {
            print("🌊Error: \(error.localizedDescription)")
        }
    }

    // MARK: - SurfSpot
    
    var allSurfSpots: Results<SurfSpot> {
        return objects(SurfSpot.self)
    }
    
    func surfSpot(for spotId: Int) -> SurfSpot? {
        return object(ofType: SurfSpot.self, forPrimaryKey: spotId)
    }
    
    func updateSurfSpots(_ spots: [SurfSpot]) {
        writeBlock {
            add(spots, update: true)
        }
    }
    
    // MARK: - SurfForecasts
    
    var allForecasts: Results<SurfForecast> {
        return objects(SurfForecast.self)
    }
    
    func currentSpotForecast(_ spot: SurfSpot) -> SurfForecast? {
        // Returns the forecast closest to the present time, which is either:
            // 1) The forecast nearest in the future
            // 2) Or if not available, the most recent forecast in the past
        if let soonestForecast = spot.forecasts
                                        .filter("date > %@", Date())
                                        .sorted(byKeyPath: "date")
                                        .first {
            return soonestForecast
        } else if let mostRecentForecast = spot.forecasts
                                            .filter("date < %@", Date())
                                            .sorted(byKeyPath: "date")
                                            .last {
            return mostRecentForecast
        }
        return nil
    }
    
    func saveForecasts(_ forecasts: [SurfForecast], for spot: SurfSpot) {
        let soonestNewForecastDate = forecasts.map({$0.date}).min() ?? Date.distantFuture
        let outdatedForecasts = spot.forecasts.filter("date > %@", soonestNewForecastDate)
        writeBlock {
            if !outdatedForecasts.isEmpty {
                delete(outdatedForecasts)
            }
            add(forecasts)
            spot.updatedAt = Date()
        }
    }
    
    // MARK: - Surf Alarms
    
    var allAlarms: Results<SurfAlarm> {
        return objects(SurfAlarm.self)
    }
    
    func alarmForSpot(with spotId: Int) -> SurfAlarm? {
        return object(ofType: SurfAlarm.self, forPrimaryKey: spotId)
    }

    func saveAlarm(_ alarm: SurfAlarm) {
        writeBlock {
            add(alarm, update: true)
        }
    }
        
    func deleteAlarm(_ alarm: SurfAlarm) {
        writeBlock {
            delete(alarm)
        }
    }
}
