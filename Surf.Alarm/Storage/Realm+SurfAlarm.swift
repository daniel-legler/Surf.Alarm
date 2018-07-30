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
        }
        catch {
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
    
    func updateSurfForecasts(_ forecasts: [SurfForecast], for spot: SurfSpot) {
        writeBlock {
            self.delete(objects(SurfForecast.self).filter("spotId = %@", spot.spotId))
            self.add(forecasts)
            spot.updatedAt = Date()
        }
    }
    
    // MARK: - Surf Alarms
    
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
    
    func allAlarms() -> Results<SurfAlarm> {
        return self.objects(SurfAlarm.self)
    }
}
