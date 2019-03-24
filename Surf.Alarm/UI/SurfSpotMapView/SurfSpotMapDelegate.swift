// Surf.Alarm

import MapKit

protocol SurfSpotMapDelegate: AnyObject {
  func userInteractedWithMap()
  func userTappedSurfSpot(at coordinate: CLLocationCoordinate2D)
}
