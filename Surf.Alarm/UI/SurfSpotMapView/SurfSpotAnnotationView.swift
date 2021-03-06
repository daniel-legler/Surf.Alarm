// Surf.Alarm
import MapKit
import Rswift

class SurfSpotAnnotationView: MKMarkerAnnotationView {
  override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
    super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
    if let annotation = annotation, let subtitle = annotation.subtitle {
      clusteringIdentifier = subtitle
    }
    titleVisibility = .visible
    subtitleVisibility = .visible
  }

  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func prepareForDisplay() {
    super.prepareForDisplay()
    displayPriority = .required
    markerTintColor = R.color.saPrimaryDark()
    glyphImage = R.image.surfboard()
  }
}
