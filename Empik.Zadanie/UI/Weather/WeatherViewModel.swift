//
//  WeatherViewModel.swift
//  Empik.Zadanie
//
//  Created by Andrey Belokovalenko on 05/02/2024.
//

import UIKit
import Combine

class WeatherViewModel: ViewModel {
    var coordinator: (any Coordinator)?
    var viewController: UIViewController!
    
    private var key: String
    private var network: NetworkProtocol
    private var request: AnyCancellable!

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
                //...
            })
    }
}
