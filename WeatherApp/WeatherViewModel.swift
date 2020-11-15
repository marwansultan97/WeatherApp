//
//  WeatherViewModel.swift
//  WeatherApp
//
//  Created by Marwan Osama on 11/8/20.
//  Copyright © 2020 Marwan Osama. All rights reserved.
//

import Foundation
import CoreLocation

class WeatherViewModel {
    
    let apiService: ApiService = ApiService()
    
    let date = Date()
    
    let vc: ViewController = ViewController()
    
    var weatherResult: WeatherModel? {
        didSet {
            self.showWeatherResults?()
        }
    }
    
    var errorMessage: String? {
        didSet {
            showErrorMessage?()
        }
    }
    
    var state: State = .empty {
        didSet {
            updateState?()
        }
    }

    
    func fetchResults() {
        state = .loading
        
        guard let latitude = vc.locationManager.location?.coordinate.latitude else {
            print("No Latitude")
            return
        }
        
        guard let longitude = vc.locationManager.location?.coordinate.longitude else {
            print("No Longitude")
            return
        }
        
        apiService.fetchWeather(lat: latitude, long: longitude) { (success, weather, err) in
            guard err == nil else {
                self.state = .failed
                self.errorMessage = err.debugDescription
                return
            }
            self.state = .done
            self.weatherResult = weather
        }
    }

    
    var showWeatherResults: (()->())?
    var showErrorMessage: (()->())?
    var updateState: (()->())?
    
    
}

enum State {
    case empty
    case loading
    case done
    case failed
    
}
