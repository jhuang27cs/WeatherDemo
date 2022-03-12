//
//  CurrentWeatherCell.swift
//  WeatherDemo
//
//  Created by Jason Huang on 2022/3/12.
//

import Foundation
import UIKit

class CurrentWeatherCell: UITableViewCell {
    
    @IBOutlet weak var wImgView: UIImageView!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var tempLbl: UILabel!
    @IBOutlet weak var humidityLbl: UILabel!
    
    private var currentDModel: CurrentModel?
    
    // MARK: - Public Methods
    
    public func loadWeatherData(data: CurrentModel?) {
        currentDModel = data
        guard let wData = currentDModel else {
            return
        }
        self.dateLbl.text = wData.dt?.toDateString(withWeekDay: true)
        self.tempLbl.text = "\(wData.temp?.decimalString() ?? "")°C"
        self.humidityLbl.text = "\(wData.humidity?.intValue ?? 0)"
        
        if let wther = wData.weather?[0] {
            self.wImgView.sd_setImage(with: URL(string: wther.iconURL ?? ""))
        }
    }
}
