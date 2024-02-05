//
//  WeatherHeaderCell.swift
//  Empik.Zadanie
//
//  Created by Andrey Belokovalenko on 05/02/2024.
//

import UIKit

class WeatherHeaderCell: UITableViewCell {

    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var feelsLikeLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setup(with weather: Weather) {
        weatherIcon.image = UIImage(named: "\(weather.weatherIcon)")
        let temp = weather.temperature.metric
        tempLabel.text = "\(Int(temp.value.rounded()))°\(temp.unit)"
        let rfTemp = weather.realFeelTemperature.metric
        feelsLikeLabel.text = "Feels like \(Int(rfTemp.value.rounded()))°"
        summaryLabel.text = weather.weatherText
    }
}
