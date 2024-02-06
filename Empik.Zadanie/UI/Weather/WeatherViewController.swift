//
//  WeatherViewController.swift
//  Empik.Zadanie
//
//  Created by Andrey Belokovalenko on 05/02/2024.
//

import UIKit

class WeatherViewController: UITableViewController, WeatherView {
    private var firstAppear = true
    
    func show(error: Error) {
        stopRefreshing()
    }
    
    var viewModel: ViewModel!
    var weatherModel: WeatherViewModel {
        viewModel as! WeatherViewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Weather"
        tableView.register(UINib(nibName: "WeatherHeaderCell", bundle: nil),
                           forCellReuseIdentifier: "WeatherHeaderCell")
        tableView.register(UINib(nibName: "ValueCell", bundle: nil),
                           forCellReuseIdentifier: "ValueCell")
        tableView.delegate = weatherModel
        tableView.dataSource = weatherModel

        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(pullToRefresh),
                                            for: .valueChanged)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if firstAppear {
            firstAppear = false
            tableView.refreshControl?.beginRefreshing()
            tableView.refreshControl?.sendActions(for: .valueChanged)
        }
    }
    
    @objc func pullToRefresh() {
        weatherModel.load()
    }
    
    func set(title: String) {
        self.title = title
    }

    func reload() {
        stopRefreshing()
        tableView.reloadData()
    }
    
    private func stopRefreshing() {
        tableView.refreshControl?.endRefreshing()
    }
}
