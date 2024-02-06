//
//  CitiesSearchViewController.swift
//  Empik.Zadanie
//
//  Created by Andrey Belokovalenko on 05/02/2024.
//

import UIKit

class CitiesSearchViewController: UIViewController, CitiesSearchView {
    func showActivity() {
        let actiivity = UIActivityIndicatorView()
        actiivity.frame.size.height = 50
        actiivity.startAnimating()
        tableView.tableFooterView = actiivity
    }
    
    func hideActivity() {
        tableView.tableFooterView = nil
    }
    
    @IBOutlet private weak var tableView: UITableView!
    
    var viewModel: ViewModel!
    
    var searchViewModel: CitiesSearchViewModel {
        viewModel as! CitiesSearchViewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // TODO: add lookup
        
        title = "Cities".localized
        navigationItem.backButtonTitle = ""
        
        searchViewModel.setup(for: tableView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        searchViewModel.viewWillAppear()
    }
    
    func reload() {
        tableView.reloadData()
    }
    
    func show(error: Error) {
        let alertController = UIAlertController(title: "Error".localized,
                                                message: error.localizedDescription,
                                                preferredStyle: .alert)
            
        let okAction = UIAlertAction(title: "OK".localized, style: .default)
        alertController.addAction(okAction)

        present(alertController, animated: true, completion: nil)
    }
}
