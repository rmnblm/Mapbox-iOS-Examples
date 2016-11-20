//
//  GeocoderViewController.swift
//  Mapbox-iOS-Examples
//
//  Created by Roman Blum on 20.11.16.
//  Copyright © 2016 rmnblm. All rights reserved.
//

import Foundation
import UIKit
import MapboxGeocoder

class GeocoderViewController: UITableViewController, UISearchResultsUpdating, UISearchBarDelegate {

    let geocoder = Geocoder(accessToken: Bundle.main.plist(named: "Keys", key: "MAPBOX_ACCESS_TOKEN"))
    let cellIdentifier = "cellIdentifier"

    var searchController: UISearchController!

    var dataArray = [String]()
    var shouldShowSearchResults = false

    var sessionTask: URLSessionTask?

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        configureSearchController()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)!
        cell.textLabel?.text = self.dataArray[indexPath.row]
        return cell
    }

    private func configureSearchController() {
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
        searchController.searchBar.sizeToFit()
        tableView.tableHeaderView = searchController.searchBar
    }

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        shouldShowSearchResults = true
        tableView.reloadData()
    }


    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        shouldShowSearchResults = false
        tableView.reloadData()
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if !shouldShowSearchResults {
            shouldShowSearchResults = true
            tableView.reloadData()
        }

        searchController.searchBar.resignFirstResponder()
    }

    func updateSearchResults(for searchController: UISearchController) {
        guard let searchString = searchController.searchBar.text else {
            return
        }

        let options = ForwardGeocodeOptions(query: searchString)
        options.allowedISOCountryCodes = ["CH"]

        sessionTask?.cancel()
        sessionTask = geocoder.geocode(options) { (placemarks, attribution, error) in
            var searchResults = [String]()
            placemarks?.forEach { placemark in
                searchResults.append(placemark.qualifiedName)
            }

            self.dataArray = searchResults
            self.tableView.reloadData()
        }
    }


}
