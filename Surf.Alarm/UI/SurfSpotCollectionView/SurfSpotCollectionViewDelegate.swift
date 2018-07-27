// Surf.Alarm

import UIKit
protocol SurfSpotsCollectionDelegate: class {
    func userScrolledToSurfSpot(_ spot: SurfSpot)
    func userTappedAddAlarm(to spot: SurfSpot)
}
