// Surf.Alarm

import UIKit
protocol SurfSpotsCollectionDelegate: class {
    func createAlarmPressed()
    func userScrolledToSurfSpot(_ spot: SurfSpot)
}
