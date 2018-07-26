// Surf.Alarm

import UIKit
import Rswift

class MainVC: UIViewController, SurfSpotMapDelegate {

    @IBOutlet weak var instructionsView: DesignableView!
    @IBOutlet weak var mapContainer: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func searchPressed(_ sender: Any) {
        let searchVC = SurfSpotSearchController(nib: R.nib.surfSpotSearchController)
        searchVC.modalPresentationStyle = .custom
        searchVC.modalTransitionStyle = .crossDissolve
        self.present(searchVC, animated: true)
    }
    
    func userInteractedWithMap() {
        self.instructionsView?.removeFromSuperview()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let map = segue.destination as? SurfSpotsMapVC {
            map.delegate = self
        }
    }
}
