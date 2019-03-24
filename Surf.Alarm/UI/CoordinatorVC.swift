// Surf.Alarm

import MapKit
import Rswift
import UIKit

class CoordinatorVC: UIViewController {
  @IBOutlet var collectionContainerView: UIView!
  @IBOutlet var collectionContainerAnchor: NSLayoutConstraint!

  var surfMap: SurfSpotsMapVC!
  var spotCollection: SurfSpotsCollectionVC!

  override func viewDidLoad() {
    super.viewDidLoad()
    showBottomMessage("Search or scroll to find your surf spot", lengthOfTime: 4)
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    checkNotificationAuthorizationStatus()
  }

  @IBAction func searchPressed(_: Any) {
    let searchVC = SurfSpotSearchController(nib: R.nib.surfSpotSearchController)
    searchVC.modalPresentationStyle = .custom
    searchVC.modalTransitionStyle = .crossDissolve
    searchVC.delegate = self
    present(searchVC, animated: true)
  }

  @IBAction func alarmPressed(_: Any) {
    if let alarmsTableScene = R.storyboard.surfAlarmTableVC.instantiateInitialViewController() {
      alarmsTableScene.modalPresentationStyle = .custom
      alarmsTableScene.modalTransitionStyle = .crossDissolve
      alarmsTableScene.delegate = self
      present(alarmsTableScene, animated: true, completion: nil)
    }
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let map = segue.destination as? SurfSpotsMapVC {
      map.delegate = self
      surfMap = map
    } else if let collection = segue.destination as? SurfSpotsCollectionVC {
      collection.delegate = self
      spotCollection = collection
    } else if segue.identifier == R.segue.coordinatorVC.showAlarmBuilder.identifier {
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

  func moveSurfSpotCollectionView(hidden: Bool) {
    UIView.animate(withDuration: 0.3) {
      let bottomConstant = hidden ? self.collectionContainerView.frame.height : -10.0
      self.collectionContainerAnchor.constant = bottomConstant
      self.view.layoutIfNeeded()
    }
  }

  func checkNotificationAuthorizationStatus() {
    NotificationAuthorizer.checkAuthorization { authorized in
      if !authorized, !NotificationAuthorizer.userDisabledNotifications {
        DispatchQueue.main.async {
          self.showAppSettingsDialog(title: "Notifications Disabled")
        }
      }
    }
  }
}

extension CoordinatorVC: SurfSpotsCollectionDelegate {
  func userScrolledToSurfSpot(_ spot: SurfSpot) {
    surfMap.moveMapToSurfSpot(spot)
  }

  func userTappedAddAlarm(to spot: SurfSpot) {
    performSegue(withIdentifier: R.segue.coordinatorVC.showAlarmBuilder, sender: spot)
  }
}

extension CoordinatorVC: SurfSpotMapDelegate {
  func userInteractedWithMap() {
    moveSurfSpotCollectionView(hidden: true)
  }

  func userTappedSurfSpot(at coordinate: CLLocationCoordinate2D) {
    moveSurfSpotCollectionView(hidden: false)
    if let spot = store.allSurfSpots.first(where: { $0.coordinate == coordinate }) {
      spotCollection.scrollToSurfSpot(spot)
    }
  }
}

extension CoordinatorVC: SurfSpotSearchDelegate {
  func userTappedSearchedSpot(_ spot: SurfSpot) {
    surfMap.moveMapToSurfSpot(spot)
    spotCollection.scrollToSurfSpot(spot)
    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
      self.moveSurfSpotCollectionView(hidden: false)
    }
  }
}

extension CoordinatorVC: SurfAlarmTableViewDelegate {
  func userTappedViewMap(for alarm: SurfAlarm) {
    guard let spot = alarm.surfSpot else { return }
    surfMap.moveMapToSurfSpot(spot)
    spotCollection.scrollToSurfSpot(spot)
    moveSurfSpotCollectionView(hidden: false)
  }
}
