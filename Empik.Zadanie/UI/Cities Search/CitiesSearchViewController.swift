//
//  CitiesSearchViewController.swift
//  Empik.Zadanie
//
//  Created by Andrey Belokovalenko on 05/02/2024.
//

import UIKit

class CitiesSearchViewController: UITableViewController, CitiesSearchView {
    var viewModel: ViewModel!
    
    var searchViewModel: CitiesSearchViewModel {
        viewModel as! CitiesSearchViewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // TODO: add lookup
        
        title = "Search City"
        
        searchViewModel.setup(for: tableView)
        
        let searchBar = UISearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.heightAnchor.constraint(equalToConstant: 40).isActive = true
        searchBar.showsCancelButton = true
        
        searchBar.delegate = searchViewModel
        tableView.tableHeaderView = searchBar
    }
    
    func reload() {
        tableView.reloadData()
    }
    
}
