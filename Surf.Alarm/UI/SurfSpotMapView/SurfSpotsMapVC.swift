// Surf.Alarm

import UIKit
import MapKit
import RealmSwift
import SpitcastSwift

class SurfSpotsMapVC: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!

    weak var delegate: SurfSpotMapDelegate?
    
    let initialLocation = CLLocation(latitude: 36.603954, longitude: -121.898460)
    let regionRadius: CLLocationDistance = 1000000
    let allSpots = store.allSurfSpots
    
    var allAnnotations: [MKPointAnnotation] {
        return allSpots.map({ (spot) -> MKPointAnnotation in
            let annotation = MKPointAnnotation()
            annotation.coordinate = spot.coordinate
            annotation.title = spot.name
            annotation.subtitle = spot.county + " County"
            return annotation
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMapView()
    }
    
    func setupMapView() {
        mapView.register(SurfSpotAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        mapView.register(ClusterAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultClusterAnnotationViewReuseIdentifier)
        
        mapView.delegate = self
        
        centerMapOnLocation(initialLocation)

        mapView.addAnnotations(allAnnotations)
    }
    
    func centerMapOnLocation(_ location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  regionRadius, regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    enum SurfMapZoomLevel {
        case singleSpot
        case cluster
    }
    
    func moveMapToSurfSpot(at coordinate: CLLocationCoordinate2D) {
        self.zoomToLocation(coordinate, zoomDepth: .singleSpot)
        if let annotation = self.getAnnotationAt(coordinate: coordinate) {
            self.mapView.selectAnnotation(annotation, animated: true)
        }
    }

    private func zoomToLocation(_ coordinate: CLLocationCoordinate2D, zoomDepth: SurfMapZoomLevel) {
        let currentSpan = mapView.region.span
        var zoomedSpan: MKCoordinateSpan
        switch zoomDepth {
        case .singleSpot:
            zoomedSpan = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        case .cluster:
            zoomedSpan = MKCoordinateSpan(latitudeDelta: currentSpan.latitudeDelta / 4.0,
                                          longitudeDelta: currentSpan.longitudeDelta / 4.0)
        }
        let zoomed = MKCoordinateRegion(center: coordinate, span: zoomedSpan)
        mapView.setRegion(zoomed, animated: true)
    }
    
    func getAnnotationAt(coordinate: CLLocationCoordinate2D) -> MKAnnotation? {
        return self.mapView.annotations.first(where: { (annotation) -> Bool in
            return annotation.coordinate == coordinate
        })
    }
}

extension SurfSpotsMapVC: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKClusterAnnotation {
            let clusterView = mapView.dequeueReusableAnnotationView(withIdentifier: "clusterView") as? ClusterAnnotationView
                ?? ClusterAnnotationView(annotation: annotation, reuseIdentifier: "clusterView")
            return clusterView
        } else {
            let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "mapItem") as? SurfSpotAnnotationView
                ?? SurfSpotAnnotationView(annotation: annotation, reuseIdentifier: "mapItem")
            return annotationView
        }
    }

    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        let coordinate = view.annotation?.coordinate ?? self.mapView.centerCoordinate
        if view is ClusterAnnotationView {
            self.zoomToLocation(coordinate, zoomDepth: .cluster)
        } else if view is SurfSpotAnnotationView && userInteractedWithMap() {
            self.zoomToLocation(coordinate, zoomDepth: .singleSpot)
            self.delegate?.userTappedSurfSpot(at: coordinate)
        }
    }
    
    func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
        if userInteractedWithMap() {
            self.delegate?.userInteractedWithMap()
        }
    }
    
    func userInteractedWithMap() -> Bool {
        if let gestureRecognizers = self.mapView.subviews.first?.gestureRecognizers {
            for gestureRecognizer in gestureRecognizers {
                if (gestureRecognizer.state == .began || gestureRecognizer.state == .ended) {
                    return true
                }
            }
        }
        return false
    }
}
