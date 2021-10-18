//
//  WeatherTests.swift
//  WeatherTests
//
//  Created by Anilkumar on 14/10/21.
//

import XCTest
import Alamofire

@testable import Weather

class WeatherTests: XCTestCase {
    
    let weatherService = WeatherService()
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    /*------------------------------------------------------
     Unit testing api call
     ------------------------------------------------------ */
    func testWeatherApiCall()  {
        
        let promise = expectation(description: "Status code: 201")
        let urlString = "http://api.weatherstack.com/current?access_key=4c3cefd4d048e2ec65c21deb76b92b76&query=Ongole"
        AF.request(urlString).response { response in
            if response.response?.statusCode == 200 || response.response?.statusCode == 201 {
                promise.fulfill()
                
            } else {
                XCTFail("Status code: Test Failed")
            }
        }
        wait(for: [promise], timeout: 10)
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
