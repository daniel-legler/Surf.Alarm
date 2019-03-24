import CenteredCollectionView
import MapKit
import RealmSwift
import Rswift
import UIKit

class SurfSpotsCollectionVC: UIViewController {
  @IBOutlet var collectionView: UICollectionView!

  let spots = store.allSurfSpots.sorted(byKeyPath: "latitude", ascending: false)
  var token: NotificationToken?
  weak var delegate: SurfSpotsCollectionDelegate?
  private var centeredCollectionViewFlowLayout: CenteredCollectionViewFlowLayout!

  override func viewDidLoad() {
    super.viewDidLoad()
    setupCollectionView()
    setupRealm()
  }

  private func setupCollectionView() {
    let nib = UINib(resource: R.nib.surfSpotCell)
    collectionView.register(
      nib,
      forCellWithReuseIdentifier: R.reuseIdentifier.surfSpotCell.identifier
    )
    centeredCollectionViewFlowLayout = (collectionView.collectionViewLayout as! CenteredCollectionViewFlowLayout)
    collectionView.decelerationRate = .fast
    collectionView.dataSource = self
    collectionView.delegate = self
    centeredCollectionViewFlowLayout.itemSize = CGSize(
      width: view.bounds.width * 0.9,
      height: collectionView.bounds.height * 0.9
    )

    centeredCollectionViewFlowLayout.minimumLineSpacing = 15
    collectionView.showsVerticalScrollIndicator = false
    collectionView.showsHorizontalScrollIndicator = false
  }

  private func setupRealm() {
    token = spots.observe { [weak self] (changes: RealmCollectionChange) in
      switch changes {
      case .initial:
        break
      case let .update(_, deletions, insertions, modifications):
        self?.collectionView.performBatchUpdates({
          self?.collectionView.deleteItems(at: deletions.map { IndexPath(item: $0, section: 0) })
          self?.collectionView.insertItems(at: insertions.map { IndexPath(item: $0, section: 0) })
          self?.collectionView.reloadItems(at: modifications.map { IndexPath(item: $0, section: 0) })
        }, completion: nil)
      case let .error(error):
        print("🌊 Realm error observing spots): \(error.localizedDescription)")
      }
    }
  }

  deinit {
    token?.invalidate()
  }

  func scrollToSurfSpot(_ spot: SurfSpot) {
    if let index = spots.index(of: spot) {
      scrollToSpotIndex(index)
    }
  }

  private func scrollToSpotIndex(_ index: Int) {
    let indexPath = IndexPath(item: index, section: 0)
    collectionView.reloadItems(at: [indexPath])
    collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
  }

  @objc func addAlarmTapped(_ sender: AddAlarmButton!) {
    delegate?.userTappedAddAlarm(to: sender.spot)
  }
}

// MARK: UICollectionViewDataSource

extension SurfSpotsCollectionVC: UICollectionViewDataSource {
  func numberOfSections(in _: UICollectionView) -> Int {
    return 1
  }

  func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
    return spots.count
  }

  func collectionView(
    _ collectionView: UICollectionView,
    cellForItemAt indexPath: IndexPath
  ) -> UICollectionViewCell {
    let spot = spots[indexPath.item]

    NetworkService.refreshForecast(for: spot)

    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.surfSpotCell, for: indexPath) else {
      return UICollectionViewCell()
    }

    cell.setLoading()
    cell.spot = spot
    cell.forecast = store.currentSpotForecast(spot)
    cell.createAlarmButton.addTarget(self,
                                     action: #selector(addAlarmTapped(_:)),
                                     for: .touchUpInside)

    return cell
  }
}

extension SurfSpotsCollectionVC: UICollectionViewDelegate {
  func scrollViewDidEndDecelerating(_: UIScrollView) {
    userScrolledToSpot()
  }

  func scrollViewDidEndScrollingAnimation(_: UIScrollView) {
    userScrolledToSpot()
  }

  private func userScrolledToSpot() {
    if let index = centeredCollectionViewFlowLayout.currentCenteredPage {
      delegate?.userScrolledToSurfSpot(spots[index])
    }
  }
}
