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
            weatherData = weatherData(from: weather)   
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
    
    private func weatherData(from weather: Weather) -> [NamedValue] {
        let wind = weather.wind.Speed.metric
        let windGusts = weather.windGust.Speed.metric
        var humidity = "--"
        if let relativeHumidity = weather.relativeHumidity {
            humidity = String(relativeHumidity)
        }
        let pressure = weather.pressure.metric
        return [
            NamedValue(name: "Wind", value: "\(wind.value) \(wind.unit)"),
            NamedValue(name: "Wind gusts", value: "\(windGusts.value) \(windGusts.unit)"),
            NamedValue(name: "Humidity", value: "\(humidity)%"),
            NamedValue(name: "Pressure", value: "\(pressure.value) \(pressure.unit) (\(weather.pressureTendency.localizedText))"),
            NamedValue(name: "Cloud Cover", value: "\(weather.cloudCover)%")
        ]
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
