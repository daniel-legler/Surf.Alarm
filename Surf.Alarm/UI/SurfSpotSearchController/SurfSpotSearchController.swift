import Rswift
import UIKit
class SurfSpotSearchController: UIViewController {
  @IBOutlet var tableView: UITableView!

  weak var delegate: SurfSpotSearchDelegate?

  private let surfSpots = Array(store.allSurfSpots.sorted(byKeyPath: "county"))
  private var filteredSpots: [SurfSpot] = []
  private var searchController: UISearchController!

  override func viewDidLoad() {
    super.viewDidLoad()
    setupSearchController()
  }

  @IBAction func closeButtonTapped(_: Any) {
    closeSearch()
  }

  private func setupSearchController() {
    searchController = UISearchController(searchResultsController: nil)
    searchController.delegate = self
    searchController.searchBar.delegate = self
    searchController.searchResultsUpdater = self
    searchController.dimsBackgroundDuringPresentation = false
    searchController.searchBar.sizeToFit()
    tableView.tableHeaderView = searchController.searchBar
    definesPresentationContext = true
    searchController.searchBar.searchBarStyle = .minimal
    searchController.searchBar.tintColor = R.color.saPrimaryDark()
  }

  private func closeSearch() {
    searchController.dismiss(animated: true)
    dismiss(animated: true, completion: nil)
  }
}

extension SurfSpotSearchController: UISearchControllerDelegate,
                                    UISearchBarDelegate,
                                    UISearchResultsUpdating {
  var isSearching: Bool {
    return searchController.isActive && !searchBarIsEmpty
  }

  var searchBarIsEmpty: Bool {
    return searchController.searchBar.text?.isEmpty ?? true
  }

  func updateSearchResults(for searchController: UISearchController) {
    if let searchText = searchController.searchBar.text?.lowercased() {
      filteredSpots = surfSpots.filter { (spot) -> Bool in
        spot.county.lowercased().contains(searchText) || spot.name.lowercased().contains(searchText)
      }
      tableView.reloadData()
    }
  }

  func searchBarCancelButtonClicked(_: UISearchBar) {
    dismiss(animated: true, completion: nil)
  }
}

extension SurfSpotSearchController: UITableViewDataSource, UITableViewDelegate {
  func numberOfSections(in _: UITableView) -> Int {
    return 1
  }

  func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
    if isSearching {
      return filteredSpots.count
    }
    return surfSpots.count
  }

  func tableView(_: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
    let spot = isSearching ? filteredSpots[indexPath.row] : surfSpots[indexPath.row]
    cell.textLabel?.text = spot.name
    cell.detailTextLabel?.text = spot.county
    cell.textLabel?.textColor = R.color.saPrimaryDark()
    cell.detailTextLabel?.textColor = UIColor.gray
    return cell
  }

  func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
    var spot: SurfSpot
    if isSearching {
      spot = filteredSpots[indexPath.row]
    } else {
      spot = surfSpots[indexPath.row]
    }
    delegate?.userTappedSearchedSpot(spot)
    closeSearch()
  }
}
