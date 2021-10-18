//
//  WeatherViewModel.swift
//  Weather
//
//  Created by Anilkumar on 17/10/21.
//

import Foundation

/*--------------------------------
 Protocol for passing data
 --------------------------------*/
protocol PassDataFromViewModelToVC {
    func SendDataToViewController(weatherInfo: Weather, error: String)
}

//MARK:- ViewModel
public class WeatherViewModel: NSObject {
    
    var cityName: String?
    var temperature: String?
    var weatherDescription: String?
    var weatherIcon: String?
    var delegate:PassDataFromViewModelToVC?
    
    public let weatherService: WeatherService
    
    public init(weatherService: WeatherService) {
        self.weatherService = weatherService
    }
    
    //MARK:- Passing data to Viewcontroller
    public func refresh() {
        
        weatherService.loadWeatherData { weather in
            print(weather)
            self.cityName = weather.city.description
            self.temperature = "\(weather.temparature)°C".description
            self.weatherDescription = weather.description.capitalized.description
            self.weatherIcon = weather.tempURL.description
            self.delegate?.SendDataToViewController(weatherInfo: weather, error: "")
        }
        
    }
    
}
