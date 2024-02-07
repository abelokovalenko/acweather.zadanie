//
//  CitiesSearchViewController.swift
//  Empik.Zadanie
//
//  Created by Andrey Belokovalenko on 05/02/2024.
//

import UIKit

class CitiesSearchViewController: UIViewController, CitiesSearchView {
    @IBOutlet private weak var tableView: UITableView!

    var viewModel: ViewModelProtocol!
    private var searchViewModel: CitiesSearchViewModel? {
        viewModel as? CitiesSearchViewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.backButtonTitle = ""
        setEmptyFooter()
        searchViewModel?.setup(for: tableView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        searchViewModel?.viewWillAppear()
    }
    
    func reload() {
        tableView.reloadData()
    }
    
    func show(error: Error) {
        dialogue(title: "Error".localized,
                 description: error.localizedDescription,
                 actionTitle: "Ok".localized)
    }
    
    func showActivity() {
        let activity = UIActivityIndicatorView()
        activity.frame.size.height = 50
        activity.startAnimating()
        tableView.tableFooterView = activity
    }
    
    func hideActivity() {
        setEmptyFooter()
    }
        
    private func setEmptyFooter() {
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 1))
    }
}
