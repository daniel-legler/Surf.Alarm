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
    
    static func refreshForecast(for spot: SurfSpot) {
        guard store.shouldRefreshForecast(for: spot) else {
            return
        }
        
        SpitcastAPI.spotForecast(id: spot.spotId) { (result) in
            result.withValue({ (forecasts) in
                let forecasts = forecasts.map({SurfForecast($0)})
                forecasts.forEach({$0.surfSpot = spot})
                store.updateSurfForecasts(forecasts, for: spot)
            })
            result.withError({ (error) in
                store.updateSurfForecasts([], for: spot)
                print("🌊Error: \(error.localizedDescription)")
            })
        }
    }
}
