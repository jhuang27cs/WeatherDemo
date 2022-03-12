//
//  DailyWeatherCell.swift
//  WeatherDemo
//
//  Created by Jason Huang on 2022/3/12.
//

import Foundation
import UIKit

class DailyWeatherCell: UITableViewCell {
    
    @IBOutlet weak var wImgView: UIImageView!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var highLbl: UILabel!
    @IBOutlet weak var lowLbl: UILabel!
    
    private var weatherMode: DailyModel?
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    public func loadWeatherData(data: DailyModel?) {
        weatherMode = data
        guard let wData = weatherMode else {
            return
        }
        self.dateLbl.text = wData.dt?.toDateString(withWeekDay: true)
        self.highLbl.text = wData.temp?.max?.twoDecimalString()
        self.lowLbl.text = wData.temp?.min?.twoDecimalString()
        
        if let wther = wData.weather?[0] {
            self.wImgView.sd_setImage(with: URL(string: wther.iconURL ?? ""))
        }
    }
}
