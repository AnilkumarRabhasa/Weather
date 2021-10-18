//
//  WeatherService.swift
//  Weather
//
//  Created by Anilkumar on 17/10/21.
//

import Foundation
import CoreLocation
import Alamofire

//MARK:- WeatherService

public final class WeatherService: NSObject {
    
    public override init() {
        super.init()
        locationManger.delegate = self
    }
    
    private let locationManger = CLLocationManager()
    private var completionHandler: ((Weather) -> Void)?
    private var API_KEY = "0b70c96fc5bfae44f72be0447ef10c3e"
    
    //MARK:- Load Data
    public func loadWeatherData(_ completionHandler: @escaping((Weather) -> Void)) {
        self.completionHandler = completionHandler
        locationManger.requestWhenInUseAuthorization()
        locationManger.startUpdatingLocation()
    }
    
    //MARK:- Make API Request
    
    public func makeDataRequest(forCoordinages coordinates: CLLocationCoordinate2D) {
        
        let location = CLLocation(latitude: coordinates.latitude, longitude:coordinates.longitude)
        location.fetchCityAndCountry { city, country, error in
            guard let city = city, error == nil else { return }
            self.locationManger.stopUpdatingLocation()
            let urlString = "http://api.weatherstack.com/current?access_key=4c3cefd4d048e2ec65c21deb76b92b76&query=\(city)"
            AF.request(urlString).response { response in
              //  debugPrint(response)
                if response.response?.statusCode == 200 || response.response?.statusCode == 201 {
                    UserDefaults.standard.removeObject(forKey: "AppleLanguages") // Resetting langauge
                    switch response.result {
                    case .success(let data):
                        if let responseData = data, let apiResponse = try? JSONDecoder().decode(WeatherAPIResponse.self, from: responseData) {
                            self.completionHandler?(Weather(response: apiResponse))
                            self.locationManger.delegate = nil
                        }
                    case .failure(let error):
                        print("error is \(error.localizedDescription)")
                    }
                }
            }
        }
    }
    
}

//MARK:- CLLocationmanager Delegate methods

extension WeatherService: CLLocationManagerDelegate {
    public func locationManager(
        _ manager: CLLocationManager,
        didUpdateLocations locations: [CLLocation]
    ) {
        guard let location = locations.first else {
            return
        }
        UserDefaults.standard.set(["base"], forKey: "AppleLanguages")  // If user switches to Hindi langauge, the city name should be english to fetch weather info from weatherstack website. So, changing language here
        print(location.coordinate)
        makeDataRequest(forCoordinages: location.coordinate)
    }
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Something went wrong: \(error.localizedDescription)")
    }
}



// MARK: - Weather API response codable
struct WeatherAPIResponse: Codable {
    let location: Location
    let current: Current
}

// MARK: - Current
struct Current: Codable {
    let observationTime: String
    let temperature, weatherCode: Int
    let weatherIcons: [String]
    let weatherDescriptions: [String]
    let windSpeed, windDegree: Int
    let windDir: String
    let pressure, precip, humidity, cloudcover: Int
    let feelslike, uvIndex, visibility: Int
    
    enum CodingKeys: String, CodingKey {
        case observationTime = "observation_time"
        case temperature
        case weatherCode = "weather_code"
        case weatherIcons = "weather_icons"
        case weatherDescriptions = "weather_descriptions"
        case windSpeed = "wind_speed"
        case windDegree = "wind_degree"
        case windDir = "wind_dir"
        case pressure, precip, humidity, cloudcover, feelslike
        case uvIndex = "uv_index"
        case visibility
    }
}

// MARK: - Location
struct Location: Codable {
    let name, country, region, lat: String
    let lon, timezoneID, localtime: String
    let localtimeEpoch: Int
    let utcOffset: String
    
    enum CodingKeys: String, CodingKey {
        case name, country, region, lat, lon
        case timezoneID = "timezone_id"
        case localtime
        case localtimeEpoch = "localtime_epoch"
        case utcOffset = "utc_offset"
    }
}
//MARK:- Fetch city name based on lat and longitude values
extension CLLocation {
    func fetchCityAndCountry(completion: @escaping (_ city: String?, _ country:  String?, _ error: Error?) -> ()) {
        CLGeocoder().reverseGeocodeLocation(self) { completion($0?.first?.locality, $0?.first?.country, $1) }
    }
}
