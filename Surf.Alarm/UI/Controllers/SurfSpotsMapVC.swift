// Surf.Alarm

import UIKit
import MapKit
import RealmSwift
import SpitcastSwift

class SurfSpotsMapVC: UIViewController {
    
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
    
    @IBOutlet weak var mapView: MKMapView!
    
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
        if view is ClusterAnnotationView {
            let currentSpan = mapView.region.span
            let zoomSpan = MKCoordinateSpan(latitudeDelta: currentSpan.latitudeDelta / 4.0, longitudeDelta: currentSpan.longitudeDelta / 4.0)
            let zoomCoordinate = view.annotation?.coordinate ?? mapView.region.center
            let zoomed = MKCoordinateRegion(center: zoomCoordinate, span: zoomSpan)
            mapView.setRegion(zoomed, animated: true)
        } else if view is SurfSpotAnnotationView {
            // Show collection view from bottom
        }
    }
}
