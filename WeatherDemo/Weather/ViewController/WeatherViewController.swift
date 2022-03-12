//
//  WeatherViewController.swift
//  WeatherDemo
//
//  Created by Jason Huang on 2022/3/12.
//

import Foundation
import UIKit
import CoreLocation
import MapKit
import MBProgressHUD

class WeatherViewController: UIViewController {
    
    @IBOutlet weak var weatherTblView: UITableView!
    @IBOutlet weak var areaBtn: UIBarButtonItem!
    
    private var locationManager = CLLocationManager()
    private let refreshControl = UIRefreshControl()
    
    // Constants
    private let currentDayIdentifier = "currentDayIdentifier"
    private let dailyIdentifier = "dailyIdentifier"
    private let storyboardName = "Weather"
    private let currentDayVCId = "CurrentDayDetailVC"
    private let estimateRowHeight = 40.0
    
    private var weatherData: OneCallAPIResponseModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.weatherTblView.estimatedRowHeight = estimateRowHeight
        refreshControl.addTarget(self, action: #selector(refreshWeatherData(_:)), for: .valueChanged)
        self.weatherTblView.refreshControl = refreshControl
        self.setupCoreLocation()
    }
    
    // MARK: - User Interactions
    
    @objc private func refreshWeatherData(_ sender: Any) {
        // Fetch Weather Data
        loadWeatherData()
    }
    
    @IBAction func areaBtnDidTapped(_ sender: UIBarButtonItem) {
        // later, we can let user select area here
    }
    
    @IBAction func refreshBtnDidtapped(_ sender: UIBarButtonItem) {
        // It's better let user refresh the data
        // if they already accepted the location service
        //
        // if (CLLocationManager.locationServicesEnabled()) {
        //      self.loadWeatherData()
        // } else
        let alert = UIAlertController(title: "", message: kPromotMsg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Allow", style: .default, handler: { (action) in
            self.setupCoreLocation()
        }))
        alert.addAction(UIAlertAction(title: "Don't Allow", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Private Methods
    
    private func loadWeatherData() {
        // Load weather by using saved latitue and longtitude
        MBProgressHUD.showAdded(to: self.view, animated: true)
        OneCallAPIRequest(latitude: Settings.latitude, longitude: Settings.longitude).start { [weak self] (request, response, error) in
            guard let `self` = self else { return }
            MBProgressHUD.hide(for: self.view, animated: true)
            if let oneCallData = response as? OneCallAPIResponseModel {
                self.refreshControl.endRefreshing()
                self.weatherData = oneCallData
                self.areaBtn.title = self.getAreaFromTimeZone()
                self.weatherTblView.reloadData()
            }
        }
    }
    
    private func setupCoreLocation() {
        locationManager.requestWhenInUseAuthorization()
        if (CLLocationManager.locationServicesEnabled()) {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        }
    }
    
    private func getAreaFromTimeZone() -> String {
        // Data sample: "America/Chicago"
        var zone = ""
        if let w = weatherData {
            zone = w.timezone ?? ""
            if let backIndex = zone.firstIndex(of: "/") {
                zone = String(zone[backIndex...])
                zone = String(zone.suffix(zone.count-1))
            }
        }
        return zone
    }
}

extension WeatherViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Current day + numOfDays
        if let data = weatherData {
            let numOfdailys = data.daily?.count ?? 0
            return numOfdailys + 1
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let rowNum = indexPath.row
        if rowNum == 0 {
            // current cell
            if let cCell = tableView.dequeueReusableCell(withIdentifier: currentDayIdentifier, for: indexPath) as? CurrentWeatherCell {
                cCell.loadWeatherData(data: weatherData?.current)
                return cCell
            }
        } else {
            // daily cell
            if let dCell = tableView.dequeueReusableCell(withIdentifier: dailyIdentifier, for: indexPath) as? DailyWeatherCell {
                dCell.loadWeatherData(data: weatherData?.daily?[rowNum-1])
                return dCell
            }
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // deSelect cell first
        tableView.deselectRow(at: indexPath, animated: false)
        guard let wD = weatherData else {
            // if weather data is nil, just return
            return
        }
        
        // Prepare WeatherModel
        var dailyWeather: WeatherModel?
        let rowNum = indexPath.row
        if rowNum == 0 {
            dailyWeather = wD.current?.weather?[0]
        } else {
            dailyWeather = wD.daily?[rowNum-1].weather?[0]
        }
        
        if let dWeather = dailyWeather {
            // before navigation, make sure weather data is not nil
            let storyboard = UIStoryboard.init(name: storyboardName, bundle: nil)
            if let vc = storyboard.instantiateViewController(withIdentifier: currentDayVCId) as? CurrentDayDetailVC {
                vc.weatherData = dWeather
                navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension WeatherViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        Settings.latitude = locValue.latitude
        Settings.longitude = locValue.longitude
        self.loadWeatherData()
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // Failed load location, load default weather
        self.loadWeatherData()
    }
}
