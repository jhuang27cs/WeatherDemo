//
//  CurrentDayDetailVC.swift
//  WeatherDemo
//
//  Created by Jason Huang on 2022/3/12.
//

import Foundation
import UIKit

class CurrentDayDetailVC: UIViewController {
    
    @IBOutlet weak var descLbl: UILabel!
    
    var weatherData: WeatherModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.descLbl.text = weatherData?.desc
    }
}
