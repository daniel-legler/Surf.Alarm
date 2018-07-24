import UIKit
import Rswift
class CountySelectorVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    let surfSpots = store.objects(SurfSpot.self)
    var searchController: UISearchController!

    var filteredCounties: [String] = []
    
    var counties: [String] {
        var countySet = Set<String>()
        for spot in surfSpots {
            countySet.insert(spot.county)
        }
        return Array(countySet).sorted()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupSearchController()
    }
    
    func setupTableView() {

    }
    
    func setupSearchController() {
        self.searchController = UISearchController(searchResultsController: nil)
        self.searchController.delegate = self
        self.searchController.searchBar.delegate = self
        self.searchController.searchResultsUpdater = self
        self.searchController.dimsBackgroundDuringPresentation = false
        self.searchController.searchBar.sizeToFit()
        self.tableView.tableHeaderView = self.searchController.searchBar
        self.definesPresentationContext = true  //default false
        self.searchController.searchBar.searchBarStyle = .minimal
    }
}

extension CountySelectorVC: UISearchControllerDelegate, UISearchBarDelegate, UISearchResultsUpdating {
    
    var isSearching: Bool {
        return searchController.isActive && !searchBarIsEmpty
    }
    
    var searchBarIsEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            filteredCounties = counties.filter({ (county) -> Bool in
                return county.lowercased().contains(searchText.lowercased())
            }).sorted()
            tableView.reloadData()
        }
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        // TODO: Dismiss the keyboard (maybe)
    }
}

extension CountySelectorVC: UITableViewDelegate {
    
}

extension CountySelectorVC: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching {
            return filteredCounties.count
        }
        return counties.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        let county = isSearching ? filteredCounties[indexPath.row] : counties[indexPath.row]
        cell.textLabel?.text = county
        return cell
    }
    
    
}
