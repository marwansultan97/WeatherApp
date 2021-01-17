//
//  WeatherViewModel.swift
//  WeatherApp
//
//  Created by Marwan Osama on 11/8/20.
//  Copyright © 2020 Marwan Osama. All rights reserved.
//

import Foundation
import CoreLocation
import Alamofire
import RxSwift
import RxCocoa

class WeatherViewModel {
    
    private let appid: String = "6f328cfddd2c01aaec6cd59ffb7aa07f"
    
    let apiService = ApiService()
    

    private var weatherModelSubject = PublishSubject<WeatherModel>()
    var weatherModelObservable: Observable<WeatherModel> {
        return weatherModelSubject.asObservable()
    }
    
    
    private var alphaWeatherView = BehaviorRelay<CGFloat>(value: 0)
    var alphaWeatherViewObservable: Observable<CGFloat> {
        return alphaWeatherView.asObservable()
    }
    
    private var isLoading = BehaviorRelay<Bool>(value: false)
    var isLoadingObservable: Observable<Bool> {
        return isLoading.asObservable()
    }
    
    private var errorMessage = BehaviorRelay<String?>(value: nil)
    var errorMessageObservable: Observable<String?> {
        return errorMessage.asObservable()
    }
    
    
    func getWeather(location: CLLocation) {
        alphaWeatherView.accept(0)
        isLoading.accept(true)
        
        let lat = location.coordinate.latitude
        let lon = location.coordinate.longitude
        let url = "http://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&appid=\(appid)&units=metric"
        
        apiService.getData(url: url, method: .get, params: nil, encoding: JSONEncoding.default, header: nil) { [weak self] (weatherModel: WeatherModel?, error) in
            guard let self = self else { return }
            self.isLoading.accept(false)
            if let error = error {
                print(error.localizedDescription)
                self.errorMessage.accept(error.localizedDescription)
            } else {
                guard let weatherModel = weatherModel else {return}
                self.weatherModelSubject.onNext(weatherModel)
                self.alphaWeatherView.accept(1)
                
                
            }
            
        }
        
    }
    
    
}





