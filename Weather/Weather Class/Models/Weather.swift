//
//  Weather.swift
//  Weather
//
//  Created by Anilkumar on 17/10/21.
//

import Foundation

//MARK:- Fetch required columns from api response
public struct Weather {
    let city: String
    let temparature: String
    let description: String
    let tempURL : String
    
    init(response: WeatherAPIResponse) {
        city = response.location.name
        temparature = String(response.current.temperature)
        description = response.current.weatherDescriptions[0]
        tempURL = response.current.weatherIcons[0]
    }
}
