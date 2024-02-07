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
        
        dialogue(title: "Error".localized,
                 description: error.localizedDescription,
                 actionTitle: "Ok".localized) { [weak self] in
            self?.weatherModel?.closeIfNoData()
        }
    }
    
    var viewModel: ViewModelProtocol!
    private var weatherModel: WeatherViewModel? {
        viewModel as? WeatherViewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "WeatherHeaderCell", bundle: nil),
                           forCellReuseIdentifier: "WeatherHeaderCell")
        tableView.register(UINib(nibName: "ValueCell", bundle: nil),
                           forCellReuseIdentifier: "ValueCell")
        tableView.register(UINib(nibName: "HourlyForecastTableViewCell", bundle: nil),
                           forCellReuseIdentifier: "HourlyForecastTableViewCell")
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
        
    func reload() {
        stopRefreshing()
        tableView.reloadData()
    }
    
    @objc
    private func pullToRefresh() {
        weatherModel?.load()
    }

    private func stopRefreshing() {
        tableView.refreshControl?.endRefreshing()
    }
}
