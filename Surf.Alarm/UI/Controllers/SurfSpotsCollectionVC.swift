import UIKit
import Rswift

private let reuseIdentifier = R.reuseIdentifier.surfSpotCell.identifier

class SurfSpotsCollectionVC: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(R.nib.surfSpotCell(),
                                forCellWithReuseIdentifier: reuseIdentifier)
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
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.surfSpotCell,
                                                                         for: indexPath) {
            return cell
        }
        return UICollectionViewCell()
    }

}
// MARK: UICollectionViewDelegate
extension SurfSpotsCollectionVC: UICollectionViewDelegate {
    
}
