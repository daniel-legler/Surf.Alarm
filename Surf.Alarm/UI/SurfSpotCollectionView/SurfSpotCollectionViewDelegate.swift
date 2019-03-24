// Surf.Alarm

import UIKit
protocol SurfSpotsCollectionDelegate: AnyObject {
  func userScrolledToSurfSpot(_ spot: SurfSpot)
  func userTappedAddAlarm(to spot: SurfSpot)
}
