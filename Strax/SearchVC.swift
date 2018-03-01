//
//  SearchVC.swift
//  Strax
//
//  Created by Karl Söderberg on 2018-03-01.
//  Copyright © 2018 LemonandLime. All rights reserved.
//

import UIKit

class SearchVC: UIViewController, UISearchBarDelegate {
    
    var searchResults = [Location]() {
        didSet {
            tableView.reloadData()
            loader.stopAnimating()
        }
    }
    @IBOutlet var tableView: UITableView!
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var loader: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.becomeFirstResponder()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchResults.removeAll()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchText = searchBar.text, !searchText.isEmpty {
            searchBar.resignFirstResponder()
            loader.startAnimating()
            search(searchText)
        }
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        dismiss(animated: true)
    }

    private func search(_ string: String) {
        let provider = SLDataProvider.sharedInstance

        provider.getLocation(string) { result in
            switch result {
            case .success(let locationModel):
                let locations = Location.createFromResponse(data: locationModel)
                self.searchResults = locations
            case .failure(let error):
                print(error)
            }
        }
    }
}

extension SearchVC: UITableViewDataSource, UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        cell.textLabel?.text = searchResults[indexPath.row].name
        cell.detailTextLabel?.text = searchResults[indexPath.row].city
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        searchResults[indexPath.row].save()
        dismiss(animated: true)
    }
}
