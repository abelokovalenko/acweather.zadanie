//
//  WeatherViewModel.swift
//  Empik.Zadanie
//
//  Created by Andrey Belokovalenko on 05/02/2024.
//

import UIKit
import Combine

enum PressureTendency: String {
    case falling = "F"
    case steady = "S"
    case rising = "R"
}

protocol WeatherView: ViewController {
    func set(title: String?)
    func reload()
}

class WeatherViewModel: NSObject, ViewModel {
    var coordinator: (any Coordinator)?
    var viewController: UIViewController! {
        didSet {
            weatherView.set(title: city.name)
        }
    }
    private var weatherView: WeatherView {
        viewController as! WeatherView
    }
    
    private var city: City
    private var network: NetworkProtocol
    private var request: AnyCancellable!
    private var weather: Weather! {
        didSet {
            weatherData = weatherData(from: weather)   
            weatherView.reload()
        }
    }
    private var weatherData = [NamedValue]()

    init(city: City, network: NetworkProtocol) {
        self.city = city
        self.network = network
    }
        
    func load() {
        request =
        network.weather(key: city.key)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                //...
            }, receiveValue: { weather in
                self.weather = weather
            })
    }
    
    private func weatherData(from weather: Weather) -> [NamedValue] {

        return [
            NamedValue(name: "Wind", value: string(for: weather.wind)),
            NamedValue(name: "Wind gusts", value: string(for: weather.windGust)),
            NamedValue(name: "Humidity", value: percentString(for: weather.relativeHumidity)),
            NamedValue(name: "Pressure", value: string(for: weather.pressure,
                                                       tendency: weather.pressureTendency)),
            NamedValue(name: "Cloud Cover", value: percentString(for: weather.cloudCover))
        ]
    }
    
    private func string(for wind: Wind) -> String {
        var directionString = ""
        if let direction = wind.direction {
            directionString = "\(direction) "
        }
        return "\(directionString)\(wind.speed.value) \(wind.speed.unit)"
    }

    private func percentString(for value: Int?) -> String {
        var valueString = "--"
        if let value = value {
            valueString = String(value)
        }
        
        return "\(valueString)%"
    }
    
    private func string(for pressure: Value, tendency: LocalizedValue) -> String {
        var tendencyString = ""
        switch PressureTendency(rawValue: tendency.code) {
        case .falling:
            tendencyString = "↓ "
        case .rising:
            tendencyString = "↑ "
        case .steady:
            tendencyString = "→ "
        default:
            break
        }
        return "\(tendencyString)\(pressure.value) \(pressure.unit)"
    }
}

extension WeatherViewModel: UITableViewDelegate {
    
}

extension WeatherViewModel: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if weather != nil {
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
