//
//  ViewController.swift
//  WeatherApp
//
//  Created by Marwan Osama on 11/7/20.
//  Copyright © 2020 Marwan Osama. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var backgroundImage: UIImageView!
    
    @IBOutlet weak var fullDate: UILabel!
    
    @IBOutlet weak var time: UILabel!
    
    @IBOutlet weak var cityName: UILabel!
    
    @IBOutlet weak var tempDegree: UILabel!
    
    @IBOutlet weak var maxTemp: UILabel!
    
    @IBOutlet weak var minTemp: UILabel!
    
    @IBOutlet weak var weatherIcon: UIImageView!
    
    @IBOutlet weak var windSpeed: UILabel!
    
    @IBOutlet weak var humidityPercent: UILabel!
    
    @IBOutlet weak var windIcon: UIImageView!
    
    @IBOutlet weak var humidityIcon: UIImageView!
    
    
    @IBOutlet weak var weatherState: UILabel!
    
        
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    lazy var viewModel: WeatherViewModel = {
        return WeatherViewModel()
    }()
    
    let locationManager = CLLocationManager()
    
    var currentLocation: CLLocation?
    
    let date = Date()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLocationManager()
        initVM()
    }

    
    func initVM() {
        
        viewModel.updateState = {
            DispatchQueue.main.async {
                switch self.viewModel.state {
                case.empty, .failed :
                    self.activityIndicator.stopAnimating()
                    self.hideEverything()
                case.loading:
                    self.activityIndicator.startAnimating()
                    self.hideEverything()
                case.done:
                    self.activityIndicator.stopAnimating()
                    self.showEverything()
                    
                }
            }
            
        }
        
        viewModel.showErrorMessage = {
            DispatchQueue.main.async {
                guard let message = self.viewModel.errorMessage else {return}
                self.showAlert(message: message)
            }
        }

        viewModel.fetchResults()

    }

    
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if !locations.isEmpty, currentLocation == nil {
            currentLocation = locations.last
            locationManager.stopUpdatingLocation()
            print(locationManager.location?.coordinate.latitude, locationManager.location?.coordinate.longitude)
            
        }
    }

    
    func showFullDate() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MMM d, yyyy"
        fullDate.text = dateFormatter.string(from: date)

    }
    
    func showTime() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        time.text = dateFormatter.string(from: date)
        print("nice")
    }

    
    func showAlert(message: String) {
        let alert: UIAlertController = UIAlertController.init(title: "error", message: message, preferredStyle: .actionSheet)
        let action: UIAlertAction = UIAlertAction.init(title: "ok", style: .cancel, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func hideEverything() {
        self.weatherIcon.image = nil
        self.cityName.text = ""
        self.weatherState.text = ""
        self.tempDegree.text = ""
        self.backgroundImage.image = nil
        self.maxTemp.text = ""
        self.minTemp.text = ""
        self.windSpeed.text = ""
        self.humidityPercent.text = ""
        self.humidityIcon.image = nil
        self.windIcon.image = nil

    }
    
    func showEverything() {
        DispatchQueue.main.async {
            guard let weather = self.viewModel.weatherResult else {
                print("No Result")
                return
            }
            self.weatherIcon.image = UIImage.init(named: weather.weather[0].icon)
            self.cityName.text = weather.sys.country + ", " + weather.name
            self.weatherState.text = weather.weather[0].weatherDescription
            self.tempDegree.text = "\(String(describing: weather.main.temp))"
            self.backgroundImage.image = UIImage(named: weather.weather[0].backgroundImage)
            self.maxTemp.text = "↑\(weather.main.tempMax)°"
            self.minTemp.text = "↓\(weather.main.tempMin)°"
            self.windSpeed.text = "\(weather.wind.speed) m/s"
            self.humidityPercent.text = "\(weather.main.humidity)%"
            self.humidityIcon.image = UIImage(named: "humidity")
            self.windIcon.image = UIImage(named: "wind")
            self.showFullDate()
            self.showTime()
        }
    }


}
