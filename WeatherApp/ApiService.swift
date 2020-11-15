//
//  ApiService.swift
//  WeatherApp
//
//  Created by Marwan Osama on 11/8/20.
//  Copyright © 2020 Marwan Osama. All rights reserved.
//

import Foundation
import CoreLocation

class ApiService {

    
    private let apiKey: String = "6f328cfddd2c01aaec6cd59ffb7aa07f"
    

    func fetchWeather(lat: Double, long: Double ,completion: @escaping (_ success: Bool, _ weather: WeatherModel?,_ err: Error?) -> ()) {
        
        let apiURL = "http://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(long)&appid=\(apiKey)&units=metric"
        
        
        guard let url = URL(string: apiURL) else {
            print("no URL")
            return
        }
        
        DispatchQueue.global().async {
            sleep(2)
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                
                if let error = error {
                    completion(false, nil, error)
                    return
                }
                
                
                do {
                    let jsonDecoder = JSONDecoder()
                    let weatherData = try jsonDecoder.decode(WeatherModel.self, from: data!)
                    completion(true, weatherData, nil)
                    
                }catch let jsonError {
                    completion(false, nil, jsonError)
                }
                
                
                
            }.resume()
        }
        
        
    }
    
    
    
}
