import Foundation
import RealmSwift
import SpitcastSwift

class RealmManager {
    
    // MARK: - Reading Data
    
    static func surfSpot(spotId: Int) -> SurfSpot? {
        do {
            let realm = try Realm()
            return realm.object(ofType: SurfSpot.self, forPrimaryKey: spotId)
        } catch {
            print("🌊Error opening Realm: \(error.localizedDescription)")
            return nil
        }
    }
    
//    static func surfSpots(county: County) -> [SurfSpot]? {
//        do {
//            let realm = try Realm()
//            return realm.objects(SurfSpot.self).filter()
//        }
//    }
    
    // MARK: - Writing Data
    
    static func updateSurfSpots(_ spots: [SCSurfSpot]) {
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
