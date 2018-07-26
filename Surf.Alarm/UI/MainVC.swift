// Surf.Alarm

import UIKit
import Rswift
import MapKit

class MainVC: UIViewController {

    @IBOutlet weak var instructionsView: DesignableView!
    @IBOutlet weak var collectionContainerView: UIView!
    var surfMap: SurfSpotsMapVC!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func searchPressed(_ sender: Any) {
        let searchVC = SurfSpotSearchController(nib: R.nib.surfSpotSearchController)
        searchVC.modalPresentationStyle = .custom
        searchVC.modalTransitionStyle = .crossDissolve
        searchVC.delegate = self
        self.present(searchVC, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let map = segue.destination as? SurfSpotsMapVC {
            map.delegate = self
            self.surfMap = map
        }
    }
}

extension MainVC: SurfSpotMapDelegate {
    
    func userInteractedWithMap() {
        UIView.animate(withDuration: 0.5, animations: {
            self.instructionsView?.alpha = 0
            self.collectionContainerView?.center.y += self.view.bounds.height
        }, completion: { _ in
            self.instructionsView?.removeFromSuperview()
        })
    }
}

extension MainVC: SurfSpotSearchDelegate {
    func selectedSpot(coordinate: CLLocationCoordinate2D) {
        self.userInteractedWithMap()
        self.surfMap.zoomToLocation(coordinate, zoomDepth: .singleSpot)
    }
}
