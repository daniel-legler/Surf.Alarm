import UIKit
import Rswift
import RealmSwift
import CenteredCollectionView
import MapKit

class SurfSpotsCollectionVC: UIViewController {
        
    @IBOutlet weak var collectionView: UICollectionView!
    var centeredCollectionViewFlowLayout: CenteredCollectionViewFlowLayout!
    weak var delegate: SurfSpotsCollectionDelegate?
    
    let spots = store.objects(SurfSpot.self).sorted(byKeyPath: "latitude", ascending: false)
    var token: NotificationToken?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(R.nib.surfSpotCell(),
                                forCellWithReuseIdentifier: R.reuseIdentifier.surfSpotCell.identifier)
        centeredCollectionViewFlowLayout = collectionView.collectionViewLayout as! CenteredCollectionViewFlowLayout
        collectionView.decelerationRate = UIScrollViewDecelerationRateFast
        collectionView.dataSource = self
        centeredCollectionViewFlowLayout.itemSize = CGSize(width: view.bounds.width * 0.9,
                                                           height: collectionView.bounds.height)
        
        centeredCollectionViewFlowLayout.minimumLineSpacing = 15
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.reloadData()
        
        token = spots.observe({ [weak self] (changes: RealmCollectionChange) in
            switch changes {
            case .update(_, let deletions, let insertions, let modifications):
                self?.collectionView.performBatchUpdates({
                    self?.collectionView.insertItems(at: insertions.map({IndexPath(item: $0, section: 0)}))
                    self?.collectionView.deleteItems(at: deletions.map({IndexPath(item: $0, section: 0)}))
                    self?.collectionView.reloadItems(at: modifications.map({IndexPath(item: $0, section: 0)}))
                }, completion: nil)
            default:
                break
            }
        })
    }
    
    deinit {
        token?.invalidate()
    }
    
    func scrollToSurfSpot(at coordinate: CLLocationCoordinate2D) {
        if let index = indexForSpot(at: coordinate) {
            self.scrollToSpotIndex(index)
        }
    }
    
    private func scrollToSpotIndex(_ index: Int) {
        let indexPath = IndexPath(item: index, section: 0)
        self.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
    }

    private func indexForSpot(at coordinate: CLLocationCoordinate2D) -> Int? {
        guard let spotIndex = spots.index(where: { $0.coordinate == coordinate }) else {
            return nil
        }
        return spotIndex
    }
    
    private func userScrolledToSpot() {
        if let index = centeredCollectionViewFlowLayout.currentCenteredPage {
            self.delegate?.userScrolledToSurfSpot(spots[index])
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        userScrolledToSpot()
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        userScrolledToSpot()
    }

    @objc func addAlarmTapped(_ sender: AddAlarmButton!) {
        self.delegate?.userTappedAddAlarm(to: sender.spot)
    }
}

// MARK: UICollectionViewDataSource

extension SurfSpotsCollectionVC: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return spots.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.surfSpotCell, for: indexPath) {
            
            let spot = spots[indexPath.item]
            Coordinator.refreshForecast(for: spot)
            let forecast = store.currentSpotForecast(spot)
            
            cell.configure(spot)
            cell.updateForecast(forecast)
            cell.createAlarmButton.addTarget(self, action: #selector(self.addAlarmTapped(_:)), for: .touchUpInside)
            return cell
        }
        return UICollectionViewCell()
    }
}
