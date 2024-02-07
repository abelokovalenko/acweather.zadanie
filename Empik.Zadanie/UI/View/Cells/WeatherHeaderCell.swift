//
//  WeatherHeaderCell.swift
//  Empik.Zadanie
//
//  Created by Andrey Belokovalenko on 05/02/2024.
//

import UIKit

class WeatherHeaderCell: UITableViewCell {

    @IBOutlet weak var background: UIView!
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var feelsLikeLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        background.layer.cornerRadius = 10
    }
    
    func setup(with weather: Weather) {
        weatherIcon.image = UIImage(named: "\(weather.weatherIcon)")
        let temp = weather.temperature
        let degrees = Int(temp.value.rounded())
        
        switch degrees {
        case _ where degrees < 10:
            tempLabel.textColor = .blue
        case 10...20:
            tempLabel.textColor = .black
        case _ where degrees > 20:
            tempLabel.textColor = .red
        default:
            tempLabel.textColor = .black
        }
        tempLabel.text = "\(degrees)°"
        let rfTemp = weather.realFeelTemperature
        feelsLikeLabel.text = "\("Feels like".localized) \(Int(rfTemp.value.rounded()))°"
        summaryLabel.text = weather.weatherText
    }
}
