// Surf.Alarm

import MapKit

protocol SurfSpotMapDelegate: class {
    func userInteractedWithMap()
    func userTappedSurfSpot(at coordinate: CLLocationCoordinate2D)
}
