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
            weatherData = [
                NamedValue(name: "Wind", value: "\(weather.wind.Speed.metric.value) \(weather.wind.Speed.metric.unit)"),
                NamedValue(name: "Wind gusts", value: "\(weather.windGust.Speed.metric.value) \(weather.windGust.Speed.metric.unit)"),
                NamedValue(name: "Humidity", value: "\(weather.relativeHumidity ?? 0)%"),
                NamedValue(name: "Pressure", value: "\(weather.pressure.metric.value) \(weather.pressure.metric.unit)")
            ]
            
            weatherView.reload()
        }
    }
    private var weatherData = [NamedValue]()

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
            return weatherData.count + 1
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherHeaderCell") as! WeatherHeaderCell
                cell.setup(with: weather)
                return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "ValueCell") as! ValueCell
        cell.setup(with: weatherData[indexPath.row - 1])
        return cell
    }
}
