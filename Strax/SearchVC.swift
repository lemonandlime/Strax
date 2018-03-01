//
//  SearchVC.swift
//  Strax
//
//  Created by Karl Söderberg on 2018-03-01.
//  Copyright © 2018 LemonandLime. All rights reserved.
//

import UIKit

class SearchVC: UIViewController {
    
    var searchResults = [Location]()
    var searchController: UISearchController!
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearch()
    }
    
    private func setupSearch() {
        definesPresentationContext = true
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        tableView.tableHeaderView = searchController.searchBar
    }
    
}

extension SearchVC: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text, !searchText.isEmpty {
            search(searchText)
        }
    }
    
    private func search(_ string: String) {
        let provider = SLDataProvider.sharedInstance
        
        provider.getLocation(string) { result in
            switch result {
            case .success(let locationModel):
                let aLocation = Location(data: locationModel)
                self.searchResults.removeAll()
                self.searchResults.append(aLocation)
                self.tableView.reloadData()
                
//                aLocation.save()
//                self.dismiss(animated: true, completion: nil)
                
            case .failure(let error):
                print(error)
            }
        }
    }
}

extension SearchVC: UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell.textLabel?.text = searchResults[indexPath.row].name
        return cell
    }
    
    
}
