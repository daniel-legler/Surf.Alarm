// Surf.Alarm

import UIKit
protocol SurfSpotsCollectionDelegate: class {
    func createAlarmPressed()
    func didScrollToSurfSpot(_ spot: SurfSpot)
}
