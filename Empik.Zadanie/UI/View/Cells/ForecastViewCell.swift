//
//  ForecastViewCell.swift
//  Empik.Zadanie
//
//  Created by Andrey Belokovalenko on 06/02/2024.
//

import UIKit

class ForecastViewCell: UICollectionViewCell {

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var tmpLabel: UILabel!

    func setup(with forecast: Forecast) {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH"
        timeLabel.text = formatter.string(from: forecast.time)
        icon.image = UIImage(named: "\(forecast.icon)")
        let degrees = Int(forecast.temperature.value.rounded())
        tmpLabel.text = "\(degrees)°"
    }
}
