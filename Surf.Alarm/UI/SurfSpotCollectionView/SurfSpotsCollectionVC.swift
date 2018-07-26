import UIKit
import Rswift
import RealmSwift
import CenteredCollectionView

class SurfSpotsCollectionVC: UIViewController {
        
    @IBOutlet weak var collectionView: UICollectionView!
    var centeredCollectionViewFlowLayout: CenteredCollectionViewFlowLayout!

    let spots = store.objects(SurfSpot.self).sorted(byKeyPath: "latitude")
    
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
    }
}

// MARK: UICollectionViewDataSource

extension SurfSpotsCollectionVC: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.surfSpotCell, for: indexPath) {
            return cell
        }
        return UICollectionViewCell()
    }
}

// MARK: UICollectionViewDelegate
extension SurfSpotsCollectionVC: UICollectionViewDelegate {
    
}

// MARK: SurfSpotCollectionViewDelegate
extension SurfSpotsCollectionVC: SurfSpotCollectionViewDelegate {
    func createAlarmPressed() {
        
    }
}
