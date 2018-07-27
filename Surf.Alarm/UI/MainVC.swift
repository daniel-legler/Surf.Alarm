// Surf.Alarm

import UIKit
import Rswift
import MapKit

class MainVC: UIViewController {

    @IBOutlet weak var instructionsView: DesignableView!
    @IBOutlet weak var collectionContainerView: UIView!
    @IBOutlet weak var collectionContainerAnchor: NSLayoutConstraint!
    
    var surfMap: SurfSpotsMapVC!
    var spotCollection: SurfSpotsCollectionVC!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.hideInstructionsBanner()
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
        } else if let collection = segue.destination as? SurfSpotsCollectionVC {
            collection.delegate = self
            self.spotCollection = collection
        }
    }
    
    func hideInstructionsBanner() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            UIView.animate(withDuration: 0.5, animations: {
                self.instructionsView?.alpha = 0
            }, completion: { _ in
                self.instructionsView?.removeFromSuperview()
            })
        }
    }
    
    func moveSurfSpotCollectionView(hidden: Bool) {
        UIView.animate(withDuration: 0.3) {
            let bottomConstant = hidden ? self.collectionContainerView.frame.height : -10.0
            self.collectionContainerAnchor.constant = bottomConstant
            self.view.layoutIfNeeded()
        }
    }
}

extension MainVC: SurfSpotsCollectionDelegate {
    func createAlarmPressed() {
        
    }
    
    func didScrollToSurfSpot(_ spot: SurfSpot) {
        self.surfMap.moveMapToSurfSpot(at: spot.coordinate)
    }
}

extension MainVC: SurfSpotMapDelegate {
    func userInteractedWithMap() {
        self.moveSurfSpotCollectionView(hidden: true)
    }
    
    func userTappedSurfSpot(at coordinate: CLLocationCoordinate2D) {
        self.moveSurfSpotCollectionView(hidden: false)
        self.spotCollection.scrollToSurfSpot(at: coordinate)
    }
}

extension MainVC: SurfSpotSearchDelegate {
    func userTappedSearchedSpot(coordinate: CLLocationCoordinate2D) {
        self.surfMap.moveMapToSurfSpot(at: coordinate)
        self.spotCollection.scrollToSurfSpot(at: coordinate)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.moveSurfSpotCollectionView(hidden: false)
        }
    }
}
