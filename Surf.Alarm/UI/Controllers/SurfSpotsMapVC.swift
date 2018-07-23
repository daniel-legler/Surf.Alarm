// Surf.Alarm

import UIKit
import MapKit
import RealmSwift

class SurfSpotsMapVC: UIViewController {
    
    let initialLocation = CLLocation(latitude: 36.603954, longitude: -121.898460)
    let regionRadius: CLLocationDistance = 1000000
    let allSpots = store.allSurfSpots
    
    var allAnnotations: [MKPointAnnotation] {
        return allSpots.map({ (spot) -> MKPointAnnotation in
            let annotation = MKPointAnnotation()
            annotation.coordinate = spot.coordinate
            return annotation
        })
    }
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        centerMapOnLocation(initialLocation)
        addSurfSpotAnnotations()
        mapView.register(SurfSpotAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
    }
    
    func centerMapOnLocation(_ location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  regionRadius, regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func addSurfSpotAnnotations() {
        mapView.addAnnotations(allAnnotations)
    }

}

extension SurfSpotsMapVC: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        return SurfSpotAnnotationView(annotation: annotation, reuseIdentifier: nil)
    }
}
