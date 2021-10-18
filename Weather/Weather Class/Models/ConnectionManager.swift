//
//  ConnectionManager.swift
//  Weather
//
//  Created by Anilkumar on 18/10/21.
//

import Foundation
import Reachability

//MARK:- Network class
class ConnectionManager {
    
    static let shared = ConnectionManager()
    private init () {}
    
    func hasConnectivity() -> Bool {
        do {
            let reachability: Reachability = try Reachability()
            let networkStatus = reachability.connection
            
            switch networkStatus {
            case .unavailable:
                return false
            case .wifi, .cellular:
                return true
            case .none:
                print("unknown")
                return false
            }
        }
        catch {
            return false
        }
    }
}
