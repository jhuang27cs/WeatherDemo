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
    
    private var weatherMode: CurrentModel?
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    public func loadWeatherData(data: CurrentModel?) {
        weatherMode = data
        guard let wData = weatherMode else {
            return
        }
        self.dateLbl.text = wData.dt?.toDateString(withWeekDay: true)
        let tempDouble: Double = wData.temp?.doubleValue ?? 0
        self.tempLbl.text = String(format: "%.2f", tempDouble)
        self.humidityLbl.text = "\(wData.humidity?.intValue ?? 0)"
        
        if let wther = wData.weather?[0] {
            self.wImgView.sd_setImage(with: URL(string: wther.iconURL ?? ""))
        }
    }
}
