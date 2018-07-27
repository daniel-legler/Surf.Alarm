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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(R.nib.surfSpotCell(),
                                forCellWithReuseIdentifier: R.reuseIdentifier.surfSpotCell.identifier)
        centeredCollectionViewFlowLayout = collectionView.collectionViewLayout as! CenteredCollectionViewFlowLayout
        collectionView.decelerationRate = UIScrollViewDecelerationRateFast
        collectionView.delegate = self
        collectionView.dataSource = self
        centeredCollectionViewFlowLayout.itemSize = CGSize(width: view.bounds.width * 0.9,
                                                           height: collectionView.bounds.height)
        
        centeredCollectionViewFlowLayout.minimumLineSpacing = 15
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.reloadData()
    }
    
    func scrollToSurfSpot(at coordinate: CLLocationCoordinate2D) {
        if let index = indexForSpot(at: coordinate) {
            self.scrollToSpotIndex(index)
        }
    }
    
    func scrollToSpotIndex(_ index: Int) {
        let indexPath = IndexPath(item: index, section: 0)
        self.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
    }

    private func indexForSpot(at coordinate: CLLocationCoordinate2D) -> Int? {
        guard let spotIndex = spots.index(where: { $0.coordinate == coordinate }) else {
            return nil
        }
        return spotIndex
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
            cell.configureCell(spot)
            return cell
        }
        return UICollectionViewCell()
    }
}

// MARK: UICollectionViewDelegate

extension SurfSpotsCollectionVC: UICollectionViewDelegate {
    
    func didScrollToSurfSpot() {
        if let index = centeredCollectionViewFlowLayout.currentCenteredPage {
            self.delegate?.didScrollToSurfSpot(spots[index])
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        didScrollToSurfSpot()
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        didScrollToSurfSpot()
    }
}
