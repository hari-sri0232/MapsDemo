//
//  MapsTabBarController.swift
//  MapsDemo
//
//  Created by Sri Hari on 14/08/20.
//  Copyright © 2020 Ojas. All rights reserved.
//

import UIKit

class MapsTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var tabs = [Tab]()
        tabs.append(.main)
        tabs.append(.history)
        
        var tabViewControllers: [UIViewController] = []
        tabs.forEach { tab in
            let viewController = tab.viewController
            viewController.tabBarItem = tab.tabBarItem
            tabViewControllers.append(viewController)
        }
        setViewControllers(tabViewControllers, animated: false)
       
    }
    
    
}

extension MapsTabBarController {
    enum Tab {
        case main, history
        
        var title: String {
            switch self {
            case .main: return NSLocalizedString("Ride", comment: "Tab bar title for Rides")
            case .history: return NSLocalizedString("History", comment: "Tab bar title for History")
           
            }
        }
        
        var iconName: String {
            switch self {
            case .main:       return "Ride_Unselect"
            case .history: return "History_Unselect"
            }
        }
        
        var selectedIconName: String {
            switch self {
            case .main:       return "Ride_Select"
            case .history: return "History_Select"
            }
        }
        
        var viewController: UINavigationController {
            switch self {
            case .main:
                let mapVC = StoryboardManager.mapsStoryboard().instantiateViewController(withIdentifier: "MapViewController") as? MapViewController
                mapVC?.title = "Book a ride"
                let mapNav = UINavigationController(rootViewController: mapVC!)
                return mapNav
            case .history:
                let historyVC = StoryboardManager.mapsStoryboard().instantiateViewController(withIdentifier: "TripsHistoryViewController") as? TripsHistoryViewController
                historyVC?.title = "Completed Trips"
                let historyNav = UINavigationController(rootViewController: historyVC!)
                 return historyNav
            }
        }
        
        var tabBarItem: UITabBarItem {
            let image = UIImage(named: iconName)
            let selectedImage = UIImage(named: selectedIconName)
            return UITabBarItem(title: title, image: image, selectedImage: selectedImage)
        }
    }
}
