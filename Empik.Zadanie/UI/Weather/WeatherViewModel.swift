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

protocol WeatherView: ViewControllerProtocol {
    func set(title: String?)
    func reload()
}

class WeatherViewModel: NSObject, ViewModelProtocol {
    var coordinator: (any CoordinatorProtocol)!
    private var weatherCoordinator: WeatherCoordinator {
        coordinator as! WeatherCoordinator
    }
    
    var viewController: ViewControllerProtocol! {
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
        }
    }
    private var forecast: [Forecast]!
    private var weatherData = [NamedValue]()

    init(city: City, network: NetworkProtocol) {
        self.city = city
        self.network = network
    }
        
    func load() {
        request = Publishers.Zip(network.weather(key: city.key),
                                 network.forecast(key: city.key))
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                if case let .failure(error) = completion {
                    self?.weatherView.show(error: error)
                }
            }, receiveValue: { weather, forecast in
                self.weather = weather
                self.forecast = forecast
                self.weatherView.reload()
            })
    }
    
    func closeIfNoData() {
        if weather == nil {
            weatherCoordinator.navigate(to: .back)
        }
    }
    
    private func weatherData(from weather: Weather) -> [NamedValue] {
        return [
            NamedValue(name: "Wind".localized, value: string(for: weather.wind)),
            NamedValue(name: "Wind gusts".localized, value: string(for: weather.windGust)),
            NamedValue(name: "Humidity".localized, value: percentString(for: weather.relativeHumidity)),
            NamedValue(name: "Pressure".localized, value: string(for: weather.pressure,
                                                       tendency: weather.pressureTendency)),
            NamedValue(name: "Cloud Cover".localized, value: percentString(for: weather.cloudCover)),
            NamedValue(name: "Precipitation".localized, value: precipitationString(for: weather))
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
    
    private func precipitationString(for weather: Weather) -> String {
        if !weather.hasPrecipitation {
            return "No".localized
        }
        
        return weather.precipitationType ?? "N/A"
    }
}

extension WeatherViewModel: UITableViewDelegate {
    
}

extension WeatherViewModel: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        weather == nil ? 0 : 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1;
        case 1:
            return weatherData.count
        case 2:
            return 1
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherHeaderCell") as! WeatherHeaderCell
            cell.setup(with: weather)
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ValueCell") as! ValueCell
            cell.setup(with: weatherData[indexPath.row])
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "HourlyForecastTableViewCell") as! HourlyForecastTableViewCell
            cell.setup(with: forecast)
            return cell
            
        default:
            break
        }

        return UITableViewCell()
    }
}
