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
    func showActivity()
    func hideActivity()
}

protocol Source {
    var count: Int { get }
    func city(at: Int) -> City?
}

extension Array<City>: Source {
    func city(at idx: Int) -> City? {
        self[safe: idx]
    }
}

class CitiesSearchViewModel: NSObject, ViewModel {
    enum State {
        case search
        case history
    }

    private var state = State.history
    private var storage: Storage! = CDStorage()
    private var searchResults = [City]() {
        didSet {
            searchView.reload()
        }
    }
    
    private var source: Source {
        switch state {
        case .history:
            return storage
        case .search:
            return searchResults
        }
    }
    
    var coordinator: (any Coordinator)?
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
    

    private func city(index: IndexPath) -> City? {
        source.city(at: index.row)
    }
    
    private var search: AnyCancellable! {
        didSet {
            if search == nil {
                searchView.hideActivity()
            }
        }
    }
    
    func search(query: String) {
        state = .search
        searchResults = []
        searchView.showActivity()
        
        search = network.searchCity(request: query)
            .receive(on: DispatchQueue.main)
            .map { $0.map { awcity in
                City(key: awcity.key,
                     description: "\(awcity.country.localizedName), \(awcity.administrativeArea.localizedName)",
                     name: awcity.localizedName)
            }}
            .sink(receiveCompletion: { [weak self] completion in
                guard let self else { return }
                
                self.searchView.hideActivity()
                if case let .failure(error) = completion {
                    self.searchView.show(error: error)
                }
            }, receiveValue: { [weak self] value in
                self?.searchResults = value
            })
    }
    
    func viewWillAppear() {
        if state == .history {
            searchView.reload()
        }
    }
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
        source.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()
        
        if let city = city(index: indexPath) {
            
            var contentConfig = cell.defaultContentConfiguration()
            contentConfig.text = city.name
            contentConfig.secondaryText = city.description
            
            cell.contentConfiguration = contentConfig
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let city = city(index: indexPath) {
            storage.append(city: city)
            searchCoordinator.navigate(with: .weather(city))
        }
    }
}

extension CitiesSearchViewModel: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        state = .history
        searchView.reload()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        search(query: searchBar.text ?? "")
    }
}
