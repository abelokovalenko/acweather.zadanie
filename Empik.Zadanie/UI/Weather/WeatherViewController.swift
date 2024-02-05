//
//  WeatherViewController.swift
//  Empik.Zadanie
//
//  Created by Andrey Belokovalenko on 05/02/2024.
//

import UIKit

class WeatherViewController: UITableViewController, WeatherView {
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
        
        weatherModel.load()
    }
    
    func reload() {
        tableView.reloadData()
    }
}
