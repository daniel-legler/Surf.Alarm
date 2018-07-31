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
    
    func getSurfSpot(spotId: Int) -> SurfSpot? {
        return self.object(ofType: SurfSpot.self, forPrimaryKey: spotId)
    }
    
    func updateSurfSpots(_ spots: [SurfSpot]) {
        writeBlock {
            self.add(spots, update: true)
        }
    }
    
    // MARK: - SurfForecasts
    
    var allForecasts: Results<SurfForecast> {
        return objects(SurfForecast.self)
    }
    
    func currentSpotForecast(_ spot: SurfSpot) -> SurfForecast? {
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
    
    func updateSurfForecasts(_ forecasts: [SurfForecast], for spot: SurfSpot) {
        let soonestNewForecastDate = forecasts.map({$0.date}).min() ?? Date.distantFuture
        let outdatedForecasts = allForecasts
                                .filter("spotId = %@ AND date > %@", spot.spotId, soonestNewForecastDate)
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
        return self.objects(SurfAlarm.self)
    }

    func saveAlarm(_ alarm: SurfAlarm) {
        writeBlock {
            self.add(alarm, update: true)
        }
    }
    
    func setAlarmState(_ alarm: SurfAlarm, enabled: Bool) {
        writeBlock {
            alarm.isEnabledByUser = enabled
        }
    }
    
    func deleteAlarm(_ alarm: SurfAlarm) {
        writeBlock {
            self.delete(alarm)
        }
    }
}
