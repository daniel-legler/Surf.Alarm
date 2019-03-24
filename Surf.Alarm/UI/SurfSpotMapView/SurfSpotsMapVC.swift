// Surf.Alarm

import MapKit
import RealmSwift
import Rswift
import UIKit

class SurfSpotsMapVC: UIViewController {
  @IBOutlet var mapView: MKMapView!

  weak var delegate: SurfSpotMapDelegate?

  let allSpots = store.allSurfSpots
  var token: NotificationToken?

  var allAnnotations: [MKPointAnnotation] {
    return allSpots.map { (spot) -> MKPointAnnotation in
      let annotation = MKPointAnnotation()
      annotation.coordinate = spot.coordinate
      annotation.title = spot.name
      annotation.subtitle = spot.county + " County"
      return annotation
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    setupMapView()
    setupRealm()
  }

  func setupMapView() {
    mapView.register(
      SurfSpotAnnotationView.self,
      forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
    mapView.register(
      ClusterAnnotationView.self,
      forAnnotationViewWithReuseIdentifier: MKMapViewDefaultClusterAnnotationViewReuseIdentifier)
    mapView.delegate = self

    setInitialLocation()
  }

  func setupRealm() {
    token = allSpots.observe { [weak self] (changes: RealmCollectionChange) in
      guard let mapVC = self else { return }
      switch changes {
      case .initial:
        mapVC.mapView.addAnnotations(mapVC.allAnnotations)
      case .update(_, _, let insertions, _):
        guard !insertions.isEmpty else { break }
        mapVC.mapView.removeAnnotations(mapVC.mapView.annotations)
        mapVC.mapView.addAnnotations(mapVC.allAnnotations)
      case let .error(error):
        print("🌊 Error Loading SurfSpots from Realm: \(error.localizedDescription)")
      }
    }
  }

  deinit {
    token?.invalidate()
  }

  private func setInitialLocation() {
    let center = CLLocationCoordinate2D(latitude: 35, longitude: -120)
    let radius: CLLocationDistance = 800_000
    let region = MKCoordinateRegion(
      center: center,
      latitudinalMeters: radius,
      longitudinalMeters: radius)
    mapView.setRegion(region, animated: true)
  }

  enum SurfMapZoomLevel {
    case singleSpot
    case cluster
  }

  func moveMapToSurfSpot(_ spot: SurfSpot) {
    zoomToLocation(spot.coordinate, zoomDepth: .singleSpot)
    if let annotation = self.getAnnotationAt(coordinate: spot.coordinate) {
      mapView.selectAnnotation(annotation, animated: true)
    }
  }

  private func zoomToLocation(_ coordinate: CLLocationCoordinate2D, zoomDepth: SurfMapZoomLevel) {
    let currentSpan = mapView.region.span
    var zoomedSpan: MKCoordinateSpan
    switch zoomDepth {
    case .singleSpot:
      zoomedSpan = MKCoordinateSpan(latitudeDelta: 0.08, longitudeDelta: 0.08)
    case .cluster:
      zoomedSpan = MKCoordinateSpan(latitudeDelta: currentSpan.latitudeDelta / 4.0,
                                    longitudeDelta: currentSpan.longitudeDelta / 4.0)
    }
    let zoomed = MKCoordinateRegion(center: coordinate, span: zoomedSpan)
    mapView.setRegion(zoomed, animated: true)
  }

  private func getAnnotationAt(coordinate: CLLocationCoordinate2D) -> MKAnnotation? {
    return mapView.annotations.first(where: { (annotation) -> Bool in
      annotation.coordinate == coordinate
    })
  }

  private func userInteractedWithMap() -> Bool {
    if let gestureRecognizers = self.mapView.subviews.first?.gestureRecognizers {
      for gestureRecognizer in gestureRecognizers {
        if gestureRecognizer.state == .began || gestureRecognizer.state == .ended {
          return true
        }
      }
    }
    return false
  }

  private func userDraggedMap() -> Bool {
    if let gestureRecognizers = self.mapView.subviews.first?.gestureRecognizers {
      for recognizer in gestureRecognizers where recognizer is UIPanGestureRecognizer {
        if recognizer.state == .began || recognizer.state == .ended {
          return true
        }
      }
    }
    return false
  }

  private func deselectAnnotations() {
    for annotation in mapView.selectedAnnotations {
      mapView.deselectAnnotation(annotation, animated: true)
    }
  }
}

extension SurfSpotsMapVC: MKMapViewDelegate {
  private var clusterViewIdentifier: String {
    return "clusterView"
  }

  private var mapItemIdentifier: String {
    return "mapItem"
  }

  func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    if annotation is MKClusterAnnotation {
      let dequeuedAnnotation = mapView.dequeueReusableAnnotationView(
        withIdentifier: clusterViewIdentifier)
      guard let clusterView = dequeuedAnnotation as? ClusterAnnotationView else {
        return ClusterAnnotationView(annotation: annotation, reuseIdentifier: clusterViewIdentifier)
      }
      return clusterView
    } else {
      let dequeuedAnnotation = mapView.dequeueReusableAnnotationView(
        withIdentifier: mapItemIdentifier)
      guard let annotationView = dequeuedAnnotation as? SurfSpotAnnotationView else {
        return SurfSpotAnnotationView(annotation: annotation, reuseIdentifier: mapItemIdentifier)
      }
      return annotationView
    }
  }

  func mapView(_: MKMapView, didSelect view: MKAnnotationView) {
    let coordinate = view.annotation?.coordinate ?? mapView.centerCoordinate
    if view is ClusterAnnotationView {
      zoomToLocation(coordinate, zoomDepth: .cluster)
    } else if view is SurfSpotAnnotationView, userInteractedWithMap() {
      zoomToLocation(coordinate, zoomDepth: .singleSpot)
      delegate?.userTappedSurfSpot(at: coordinate)
    }
  }

  func mapView(_: MKMapView, didDeselect _: MKAnnotationView) {
    if userInteractedWithMap() {
      delegate?.userInteractedWithMap()
    }
  }

  func mapView(_: MKMapView, regionWillChangeAnimated _: Bool) {
    if userInteractedWithMap() {
      delegate?.userInteractedWithMap()
    }
  }

  func mapView(_: MKMapView, regionDidChangeAnimated _: Bool) {
    if userDraggedMap() {
      deselectAnnotations()
    }
  }
}
