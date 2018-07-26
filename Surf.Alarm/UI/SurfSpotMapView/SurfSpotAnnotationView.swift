// Surf.Alarm
import MapKit
import Rswift

class SurfSpotAnnotationView: MKMarkerAnnotationView {
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        if let annotation = annotation, let subtitle = annotation.subtitle {
            clusteringIdentifier = subtitle
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForDisplay() {
        super.prepareForDisplay()
        displayPriority = .defaultLow
        markerTintColor = R.color.surfTintPrimary()
        glyphImage = R.image.surfboard()
    }
}
