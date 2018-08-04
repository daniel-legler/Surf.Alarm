import UIKit
import Rswift
class SurfSpotSearchController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    weak var delegate: SurfSpotSearchDelegate?
    
    private let surfSpots = Array(store.allSurfSpots.sorted(byKeyPath: "county"))
    private var filteredSpots: [SurfSpot] = []
    private var searchController: UISearchController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchController()
    }
    
    @IBAction func closeButtonTapped(_ sender: Any) {
        self.closeSearch()
    }

    private func setupSearchController() {
        self.searchController = UISearchController(searchResultsController: nil)
        self.searchController.delegate = self
        self.searchController.searchBar.delegate = self
        self.searchController.searchResultsUpdater = self
        self.searchController.dimsBackgroundDuringPresentation = false
        self.searchController.searchBar.sizeToFit()
        self.tableView.tableHeaderView = self.searchController.searchBar
        self.definesPresentationContext = true
        self.searchController.searchBar.searchBarStyle = .minimal
        self.searchController.searchBar.tintColor = R.color.saPrimaryDark()
    }
    
    private func closeSearch() {
        self.searchController.dismiss(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
}

extension SurfSpotSearchController: UISearchControllerDelegate, UISearchBarDelegate, UISearchResultsUpdating {
    
    var isSearching: Bool {
        return searchController.isActive && !searchBarIsEmpty
    }
    
    var searchBarIsEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text?.lowercased() {
            filteredSpots = surfSpots.filter({ (spot) -> Bool in
                return spot.county.lowercased().contains(searchText) || spot.name.lowercased().contains(searchText)
            })
            tableView.reloadData()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension SurfSpotSearchController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching {
            return filteredSpots.count
        }
        return surfSpots.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        let spot = isSearching ? filteredSpots[indexPath.row] : surfSpots[indexPath.row]
        cell.textLabel?.text = spot.name
        cell.detailTextLabel?.text = spot.county
        cell.textLabel?.textColor = R.color.saPrimaryDark()
        cell.detailTextLabel?.textColor = UIColor.gray
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var spot: SurfSpot
        if self.isSearching {
            spot = filteredSpots[indexPath.row]
        } else {
            spot = surfSpots[indexPath.row]
        }
        self.delegate?.userTappedSearchedSpot(spot)
        self.closeSearch()
    }

}
