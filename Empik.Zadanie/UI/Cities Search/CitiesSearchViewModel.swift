//
//  CitiesSearchViewModel.swift
//  Empik.Zadanie
//
//  Created by Andrey Belokovalenko on 05/02/2024.
//

import UIKit
import Combine

protocol CitiesSearchView: ViewControllerProtocol {
    func reload()
    func showActivity()
    func hideActivity()
}

extension Array<City>: CitiesSourceProtocol {
    func city(at idx: Int) -> City? {
        self[safe: idx]
    }
}

class CitiesSearchViewModel: NSObject, ViewModelProtocol {
    private enum State {
        case search
        case history
    }

    var coordinator: (any CoordinatorProtocol)!
    private var searchCoordinator: CitiesSearchCoordinator {
        coordinator as! CitiesSearchCoordinator
    }
    
    weak var viewController: ViewControllerProtocol!
    private var searchView: CitiesSearchView {
        viewController as! CitiesSearchView
    }

    private var state = State.history {
        didSet {
            updateTitle()
        }
    }
    private var storage: Storage! = CDStorage() // TODO: make dependency
    private var searchResults = [City]()
    
    private var source: CitiesSourceProtocol {
        switch state {
        case .history:
            return storage
        case .search:
            return searchResults
        }
    }
    
    private var showEmpty = true
    private let network: NetworkProtocol
    
    init(network: NetworkProtocol) {
        self.network = network
    }
    
    func setup(for tableView: UITableView) {
        tableView.delegate = self
        tableView.dataSource = self
        updateTitle()
    }
    
    func viewWillAppear() {
        if state == .history {
            searchView.reload()
        }
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
    
    private func search(query: String?) {
        guard let query, query.count > 0 else { return }
        
        state = .search
        showEmpty = false
        searchResults = []
        searchView.reload()
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
                self.showEmpty = true
                self.searchView.reload()
            }, receiveValue: { [weak self] value in
                guard let self else { return }

                self.searchResults = value
            })
    }
    
    private func updateTitle() {
        switch state {
        case .history:
            searchView.set(title: "Recent Cities".localized)
            showEmpty = true
        case .search:
            searchView.set(title: "Search".localized)
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
        searchBar.placeholder = "Search for city".localized
        searchBar.showsCancelButton = true

        searchBar.delegate = self

        return searchBar
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = source.count
        if count == 0 && showEmpty {
            return 1
        }
        return count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()
        var contentConfig = cell.defaultContentConfiguration()

        if let city = city(index: indexPath) {
            contentConfig.text = city.name
            contentConfig.secondaryText = city.description
        } else {
            switch state {
            case .history:
                contentConfig.text = "No recent cities".localized
                contentConfig.secondaryText = "Your viewed cities will appear here".localized
            case .search:
                contentConfig.text = "Nothing found".localized
            }
            contentConfig.textProperties.alignment = .center
            contentConfig.secondaryTextProperties.alignment = .center
        }
        
        cell.contentConfiguration = contentConfig
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let city = city(index: indexPath) {
            storage.append(city: city)
            searchCoordinator.navigate(to: .weather(city))
        }
    }
}

extension CitiesSearchViewModel: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {

        let hyphen: CharacterSet = ["-"]
        
        let lettersAndSpace = CharacterSet.letters
            .union(CharacterSet.whitespacesAndNewlines)
            .union(hyphen)
        return lettersAndSpace.isSuperset(of: CharacterSet(charactersIn: text))
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        state = .history
        searchView.reload()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        search(query: searchBar.text)
    }
}
