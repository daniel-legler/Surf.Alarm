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
    
    @IBAction func alarmPressed(_ sender: Any) {
        if let alarmsTableScene = R.storyboard.surfAlarmTableVC.instantiateInitialViewController() {
            alarmsTableScene.modalPresentationStyle = .custom
            alarmsTableScene.modalTransitionStyle = .crossDissolve
            alarmsTableScene.delegate = self
            self.present(alarmsTableScene, animated: true, completion: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let map = segue.destination as? SurfSpotsMapVC {
            map.delegate = self
            self.surfMap = map
        } else if let collection = segue.destination as? SurfSpotsCollectionVC {
            collection.delegate = self
            self.spotCollection = collection
        } else if segue.identifier == R.segue.mainVC.showAlarmBuilder.identifier {
            guard
                let navController = segue.destination as? UINavigationController,
                let alarmBuilder = navController.topViewController as? SurfAlarmBuilderVC,
                let spot = sender as? SurfSpot
            else {
                    return
            }
            alarmBuilder.configure(with: spot)
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
    func userScrolledToSurfSpot(_ spot: SurfSpot) {
        self.surfMap.moveMapToSurfSpot(at: spot.coordinate)
    }
    
    func userTappedAddAlarm(to spot: SurfSpot) {
        self.performSegue(withIdentifier: R.segue.mainVC.showAlarmBuilder, sender: spot)
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

extension MainVC: SurfAlarmTableViewDelegate {
    func userTappedViewMap(for alarm: SurfAlarm) {
        let coordinate = CLLocationCoordinate2D(latitude: alarm.latitude, longitude: alarm.longitude)
        self.surfMap.moveMapToSurfSpot(at: coordinate)
        self.spotCollection.scrollToSurfSpot(at: coordinate)
        self.moveSurfSpotCollectionView(hidden: false)
    }
}
