//
//  HourlyForecastTableViewCell.swift
//  Empik.Zadanie
//
//  Created by Andrey Belokovalenko on 06/02/2024.
//

import UIKit

class HourlyForecastTableViewCell: UITableViewCell {

    @IBOutlet weak var collectionView: UICollectionView!
    
    private var forecasts = [Forecast]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        collectionView.register(UINib(nibName: "ForecastViewCell", bundle: nil),
                                forCellWithReuseIdentifier: "ForecastViewCell")
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.layer.cornerRadius = 10
        collectionView.layer.borderColor = UIColor.lightGray.cgColor
        collectionView.layer.borderWidth = 0.5
    }
 
    func setup(with forecasts: [Forecast]) {
        self.forecasts = forecasts
        collectionView.reloadData()
    }
}

extension HourlyForecastTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        forecasts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ForecastViewCell", for: indexPath) as! ForecastViewCell
        
        cell.setup(with: forecasts[indexPath.row])
        
        return cell
    }
}

extension HourlyForecastTableViewCell: UICollectionViewDelegate {
    
}

extension HourlyForecastTableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 60, height: 80)
    }
}
