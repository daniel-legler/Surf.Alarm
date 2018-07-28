// Surf.Alarm
import MapKit
import Rswift

class ClusterAnnotationView: MKMarkerAnnotationView {
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        collisionMode = .circle
        centerOffset = CGPoint(x: 0, y: -10)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var annotation: MKAnnotation? {
        didSet {
            guard annotation is MKClusterAnnotation else { return }
            markerTintColor = R.color.surfTintPrimary()            
            displayPriority = .defaultHigh
        }
    }
}
