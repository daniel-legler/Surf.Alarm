import UIKit
import Rswift
import RealmSwift
import CenteredCollectionView
import MapKit

class SurfSpotsCollectionVC: UIViewController {
        
    @IBOutlet weak var collectionView: UICollectionView!
    
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
        collectionView.register(R.nib.surfSpotCell(),
                                forCellWithReuseIdentifier: R.reuseIdentifier.surfSpotCell.identifier)
        centeredCollectionViewFlowLayout = (collectionView.collectionViewLayout as! CenteredCollectionViewFlowLayout)
        collectionView.decelerationRate = .fast
        collectionView.dataSource = self
        collectionView.delegate = self
        centeredCollectionViewFlowLayout.itemSize = CGSize(width: view.bounds.width * 0.9,
                                                           height: collectionView.bounds.height * 0.9)
        
        centeredCollectionViewFlowLayout.minimumLineSpacing = 15
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
    }
    
    private func setupRealm() {
        token = spots.observe({ [weak self] (changes: RealmCollectionChange) in
            switch changes {
            case .initial:
                break
            case .update(_, let deletions, let insertions, let modifications):
                self?.collectionView.performBatchUpdates({
                    self?.collectionView.deleteItems(at: deletions.map({IndexPath(item: $0, section: 0)}))
                    self?.collectionView.insertItems(at: insertions.map({IndexPath(item: $0, section: 0)}))
                    self?.collectionView.reloadItems(at: modifications.map({IndexPath(item: $0, section: 0)}))
                }, completion: nil)
            case .error(let error):
                print("🌊 Realm error observing spots): \(error.localizedDescription)")
                break
            }
        })
    }
    
    deinit {
        token?.invalidate()
    }
    
    func scrollToSurfSpot(_ spot: SurfSpot) {
        if let index = spots.index(of: spot) {
            self.scrollToSpotIndex(index)
        }
    }
    
    private func scrollToSpotIndex(_ index: Int) {
        let indexPath = IndexPath(item: index, section: 0)
        self.collectionView.reloadItems(at: [indexPath])
        self.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
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
        
        let spot = spots[indexPath.item]
        
        NetworkService.refreshForecast(for: spot)

        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.surfSpotCell, for: indexPath) else {
            return UICollectionViewCell()
        }

        cell.setLoading()
        cell.spot = spot
        cell.forecast = store.currentSpotForecast(spot)
        cell.createAlarmButton.addTarget(self,
                                         action: #selector(self.addAlarmTapped(_:)),
                                         for: .touchUpInside)
        
        return cell
    }
}

extension SurfSpotsCollectionVC: UICollectionViewDelegate {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        userScrolledToSpot()
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        userScrolledToSpot()
    }
    
    private func userScrolledToSpot() {
        if let index = centeredCollectionViewFlowLayout.currentCenteredPage {
            self.delegate?.userScrolledToSurfSpot(spots[index])
        }
    }
}
