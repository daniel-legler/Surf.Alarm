import SpitcastSwift

class Coordinator {
    
    static func refreshAllSurfSpots() {
        SpitcastAPI.allSpots { (result) in
            result.withValue({ (spots) in
                let spots = spots.map({SurfSpot($0)})
                store.updateSurfSpots(spots)
            })
            result.withError({ (error) in
                print("🌊Error: \(error.localizedDescription)")
            })
        }
    }
}
