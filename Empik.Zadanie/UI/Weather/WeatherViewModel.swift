//
//  WeatherViewModel.swift
//  Empik.Zadanie
//
//  Created by Andrey Belokovalenko on 05/02/2024.
//

import UIKit
import Combine

protocol WeatherView: ViewController {
    func reload()
}

class WeatherViewModel: NSObject, ViewModel {
    var coordinator: (any Coordinator)?
    var viewController: UIViewController!
    private var weatherView: WeatherView {
        viewController as! WeatherView
    }
    
    private var key: String
    private var network: NetworkProtocol
    private var request: AnyCancellable!
    private var weather: Weather! {
        didSet {
            weatherView.reload()
        }
    }

    init(key: String, network: NetworkProtocol) {
        self.key = key
        self.network = network
    }
    
    func load() {
        request =
        network.weather(key: key)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                //...
            }, receiveValue: { weather in
                self.weather = weather
            })
    }
}

extension WeatherViewModel: UITableViewDelegate {
    
}

extension WeatherViewModel: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let weather {
            return 1
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherHeaderCell") as? WeatherHeaderCell {
            cell.setup(with: weather)
            return cell
        }
        
        return UITableViewCell()
    }
}
