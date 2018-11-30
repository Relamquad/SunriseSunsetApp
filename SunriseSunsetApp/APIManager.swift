//
//  Networking.swift
//  SunriseSunsetApp
//
//  Created by Konstantin Kalivod on 11/26/18.
//  Copyright © 2018 Kostya Kalivod. All rights reserved.
//

import Foundation
import Alamofire

class APIManager {
    
    class func getSunInfoFrom(lat: Double, long: Double, completion: @escaping (String, String) -> ()) {
        
        let baseURL = "https://api.sunrise-sunset.org/json?lat=\(lat)&lng=\(long)"
        
        Alamofire.request(baseURL).responseJSON { response in
            
            guard response.result.isSuccess else {
                print("Ошибка при запросе данных \(String(describing: response.result.error))")
                return
            }
            
            if let JSON = response.result.value as? Dictionary<String, Any> {
                
                print("JSON = \(JSON)")
                
                let result = JSON["results"] as? [String: Any]
                
                let sunset = result?["sunset"] as? String ?? ""
                let sunrise = result?["sunrise"] as? String ?? ""
                
                completion(sunset, sunrise)
                
            } else {
                print("Не могу перевести в JSON")
                return
            }
        }
    }
    
    class func getSunInfoIn(place: String, completion: @escaping (String, String) -> ()) {

        let baseURL = "https://maps.googleapis.com/maps/api/place/textsearch/json?query=\(place)&key=AIzaSyBCmiAi-SgtYNvYzuwwCNjR2rFDtdoOKlo"
        
        Alamofire.request(baseURL).responseJSON { response in
            
            guard response.result.isSuccess else {
                print("Ошибка при запросе данных \(String(describing: response.result.error))")
                return
            }
            
            if let JSON = response.result.value as? Dictionary<String, AnyObject> {
                
                let results = JSON["results"] as?  [Dictionary<String, Any>]
                
                print("JSON == \(results)")
                
                let geometry = results?.first?["geometry"] as? [String: Any]
                
                let location = geometry?["location"] as? [String: Any]
                
                let lat = location?["lat"] as? Double ?? 0
                let lng = location?["lng"] as? Double ?? 0
                
                APIManager.getSunInfoFrom(lat: lat, long: lng, completion: { (sunset, sunrise) in
                    completion(sunset, sunrise)
                })
                
            } else {
                print ("Error Google JSON")
            }
        }
    }
}

