import SpitcastSwift

class Coordinator {
    
    static func refreshAllSurfSpots() {
        SpitcastAPI.allSpots { (result) in
            result.withValue({ (spots) in
                RealmManager.updateSurfSpots(spots)
            })
            result.withError({ (error) in
                print("🌊Error: \(error.localizedDescription)")
            })
        }
    }
    
    
}
