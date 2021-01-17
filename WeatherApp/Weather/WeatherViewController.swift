//
//  ViewController.swift
//  WeatherApp
//
//  Created by Marwan Osama on 11/7/20.
//  Copyright © 2020 Marwan Osama. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
import RxSwift
import RxCocoa

@available(iOS 13.0, *)
class WeatherViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var weatherView: UIView!
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
    @IBOutlet weak var weatherState: UILabel!
    
        
    
    
    lazy var viewModel: WeatherViewModel = {
        return WeatherViewModel()
    }()
    
    let bag = DisposeBag()
    
    let locationManager = CLLocationManager()
    
    let refreshControl = UIRefreshControl()
    
    var date = Date()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.weatherView.accessibilityScroll(.down)
        bindToWeatherResult()
        setupLocationManager()
        showFullDate()
        showTime()
        setRefreshAttributes()
        navigationController?.navigationBar.isHidden = true
        
        
    }
    
    @objc func refresh(_ sender: AnyObject) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+1) {
            self.date = Date()
            self.showTime()
            self.showFullDate()
            self.viewModel.getWeather(location: self.locationManager.location!)
            self.refreshControl.endRefreshing()
        }
        
    }
    
    func setRefreshAttributes() {
        scrollView.addSubview(refreshControl)
        let attributes = NSAttributedString(string: "refreshing", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 12), NSAttributedString.Key.foregroundColor: UIColor.label])
        refreshControl.attributedTitle = attributes
        refreshControl.backgroundColor = .systemBackground
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        
    }
    
    
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            print(location.coordinate)
            viewModel.getWeather(location: location)
            locationManager.stopUpdatingLocation()
            
        }
    }
    
    func bindToWeatherResult() {
        viewModel.weatherModelObservable.map { "\($0.main.temp)" }.bind(to: tempDegree.rx.text).disposed(by: bag)
        viewModel.weatherModelObservable.map { "↓\($0.main.tempMin)" }.bind(to: minTemp.rx.text).disposed(by: bag)
        viewModel.weatherModelObservable.map { "↑\($0.main.tempMax)" }.bind(to: maxTemp.rx.text).disposed(by: bag)
        viewModel.weatherModelObservable.map { $0.sys.country + ", " + $0.name }.bind(to: cityName.rx.text).disposed(by: bag)
        viewModel.weatherModelObservable.map { "\($0.wind.speed)" }.bind(to: windSpeed.rx.text).disposed(by: bag)
        viewModel.weatherModelObservable.map { "\($0.main.humidity)%" }.bind(to: humidityPercent.rx.text).disposed(by: bag)
        viewModel.weatherModelObservable.map { UIImage(named: "\($0.weather[0].icon)") }.bind(to: weatherIcon.rx.image).disposed(by: bag)
        viewModel.weatherModelObservable.map { UIImage(named: "\($0.weather[0].backgroundImage)") }.bind(to: backgroundImage.rx.image).disposed(by: bag)
        viewModel.weatherModelObservable.map { $0.weather[0].weatherDescription }.bind(to: weatherState.rx.text).disposed(by: bag)
        viewModel.alphaWeatherViewObservable.bind(to: weatherView.rx.alpha).disposed(by: bag)
        viewModel.isLoadingObservable.subscribe(onNext: { (isLoading) in
            if isLoading {
                self.showIndicator(withTitle: "Loading", andDescription: "")
            } else {
                self.hideIndicator()
            }
        }).disposed(by: bag)
        
        viewModel.errorMessageObservable.subscribe(onNext: { (message) in
            if message != nil {
                self.showAlert(withTitle: "Error", andDescription: message, andImageName: nil, completion: nil)
            }
        }).disposed(by: bag)
        
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
    }



}
