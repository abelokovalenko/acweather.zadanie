//
//  CitiesSearchViewModel.swift
//  Empik.Zadanie
//
//  Created by Andrey Belokovalenko on 05/02/2024.
//

import UIKit
import Combine

protocol CitiesSearchView: ViewController {
    func reload()
}

class CitiesSearchViewModel: NSObject, ViewModel {
    var coordinator: Coordinator!
    private var searchCoordinator: CitiesSearchCoordinator {
        coordinator as! CitiesSearchCoordinator
    }
    
    weak var viewController: UIViewController!
    private var searchView: CitiesSearchView {
        viewController as! CitiesSearchView
    }
    
    private let network: NetworkProtocol
    
    init(network: NetworkProtocol) {
        self.network = network
    }
    
    func setup(for tableView: UITableView) {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private var found = [City]() {
        didSet {
            isSearching = false
            searchView.reload()
        }
    }
    private var isSearching = false
    
    private var search: AnyCancellable!
}

extension CitiesSearchViewModel: UITableViewDelegate {
    
}

extension CitiesSearchViewModel: UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        50
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let searchBar = UISearchBar()
        searchBar.showsCancelButton = true
        
        searchBar.delegate = self
        
        return searchBar
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        isSearching ? 0 : found.count
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if isSearching {
            let progress = UIActivityIndicatorView()
            progress.startAnimating()
            return progress
        }
        
        return nil
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()
        
        let city = found[indexPath.row]
        
        var contentConfig = cell.defaultContentConfiguration()
        contentConfig.text = city.localizedName
        contentConfig.secondaryText = "\(city.country.localizedName), \(city.administrativeArea.localizedName)"
        
        cell.contentConfiguration = contentConfig
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        searchCoordinator.id = found[indexPath.row].key
        searchCoordinator.start()
    }
}

extension CitiesSearchViewModel: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        isSearching = true
        
        search = network.searchCity(request: searchBar.text ?? "")
            .replaceError(with: [])
            .receive(on: DispatchQueue.main)
            .assign(to: \.found, on: self)
        searchBar.resignFirstResponder()
    }
}
