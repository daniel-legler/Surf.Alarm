// Surf.Alarm

import MapKit
import UIKit

protocol SurfSpotMapDelegate: class {
    func userInteractedWithMap()
    func userTappedSurfSpot(at coordinate: CLLocationCoordinate2D)
}
