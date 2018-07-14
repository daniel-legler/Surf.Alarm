import Foundation
import RealmSwift

class RealmManager {
    
    // MARK: - Reading Data
    
    static func surfSpot(spotId: Int) -> SurfSpot? {
        do {
            let realm = try Realm()
            return realm.object(ofType: SurfSpot.self, forPrimaryKey: spotId)
        } catch {
            print("Error opening Realm: \(error.localizedDescription)")
            return nil
        }
    }
    
    static func refreshAllSpots() {
        SpitcastClient.allSpots { (spotResult) in
            spotResult.withValue({ (spots) in
                persistSurfSpots(spots)
            })
        }
    }
    
    private static func persistSurfSpots(_ spots: [SpitcastSpot]) {
        do {
            let surfSpots = spots.map({SurfSpot($0)})
            let realm = try Realm()
            try realm.write {
                realm.add(surfSpots, update: true)
            }
        } catch {
            print("🌊Error: \(error.localizedDescription)")
        }
    }
    
    
}
