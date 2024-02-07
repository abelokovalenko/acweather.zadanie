//
//  ValueCell.swift
//  ACWeather.Zadanie
//
//  Created by Andrey Belokovalenko on 05/02/2024.
//

import UIKit

class ValueCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    
    func setup(with value: NamedValue) {
        nameLabel.text = value.name
        valueLabel.text = value.value
    }
}
