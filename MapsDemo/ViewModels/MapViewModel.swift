//
//  MapViewModel.swift
//  MapsDemo
//
//  Created by Sri Hari on 16/08/20.
//  Copyright © 2020 Ojas. All rights reserved.
//

import Foundation
import UIKit
import GooglePlaces
import GoogleMaps
import SwiftyJSON

class MapViewModel {
    
    
    func getRoutes(sourcePlace: GMSPlace?, destinationPlace: GMSPlace?, completionHandler:@escaping([String:Any]?, StatusMessage?)->()) {
        let souceCoordinates = "\(sourcePlace?.coordinate.latitude ?? 0.0),\( sourcePlace?.coordinate.longitude ?? 0.0)"
        let dsetinationCoordinates = "\(destinationPlace?.coordinate.latitude ?? 0.0),\( destinationPlace?.coordinate.longitude ?? 0.0)"
        let url = "https://maps.googleapis.com/maps/api/directions/json?origin=\(souceCoordinates  )&destination=\(dsetinationCoordinates)&mode=driving&key=\(GOOGLE_API_KEY)"
        
        ServiceManager.shared.get(urlString: url, params: nil, token: nil) { (data, error) in
            guard let responseData = data else { return }
            do {
                // make sure this JSON is in the format we expect
                if let json = try JSONSerialization.jsonObject(with: responseData, options: []) as? [String: Any] {
                    DispatchQueue.main.async {
                        print("ResponseObj:\(json)")
                        completionHandler(json,.success)
                    }
                    
                }
            } catch let error as NSError {
                print(error.localizedDescription)
                completionHandler(nil, .error(desc: error.localizedDescription))
            }
        }
        
    }
    
}
