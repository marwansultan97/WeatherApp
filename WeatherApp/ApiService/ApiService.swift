//
//  ApiService.swift
//  WeatherApp
//
//  Created by Marwan Osama on 11/8/20.
//  Copyright © 2020 Marwan Osama. All rights reserved.
//

import Foundation
import CoreLocation
import Alamofire

class ApiService {

    
    

//    func fetchWeather(lat: Double, long: Double ,completion: @escaping (_ success: Bool, _ weather: WeatherModel?,_ err: Error?) -> ()) {
//
//        let apiURL = "http://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(long)&appid=\(apiKey)&units=metric"
//
//
//        guard let url = URL(string: apiURL) else {
//            print("no URL")
//            return
//        }
//
//        DispatchQueue.global().async {
//            sleep(2)
//            URLSession.shared.dataTask(with: url) { (data, response, error) in
//                if let error = error {
//                    completion(false, nil, error)
//                    return
//                }
//                do {
//                    let jsonDecoder = JSONDecoder()
//                    let weatherData = try jsonDecoder.decode(WeatherModel.self, from: data!)
//                    completion(true, weatherData, nil)
//
//                }catch let jsonError {
//                    completion(false, nil, jsonError)
//                }
//
//            }.resume()
//        }
//
//
//    }
    
    func getData<T: Decodable>(url: String, method: HTTPMethod, params: Parameters?, encoding: ParameterEncoding, header: HTTPHeaders?, completion: @escaping(T?, Error?)-> Void) {
        
        AF.request(url, method: method, parameters: params, encoding: encoding, headers: header).responseJSON { (response) in
            
            switch response.result {
            case.success(_) :
                guard let data = response.data else { return }
                do {
                    let jsonData = try JSONDecoder().decode(T.self, from: data)
                    completion(jsonData, nil)
                } catch let jsonErr {
                    completion(nil, jsonErr)
                }
            case .failure(let err):
                completion(nil, err)
            }
        }
        
    }
    
}
