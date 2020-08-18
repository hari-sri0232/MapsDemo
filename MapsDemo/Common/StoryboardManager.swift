//
//  StoryboardManager.swift
//  MapsDemo
//
//  Created by Sri Hari on 14/08/20.
//  Copyright © 2020 Ojas. All rights reserved.
//

import Foundation
import UIKit

class StoryboardManager {
    
    class func mainStoryboard() -> UIStoryboard {
        return UIStoryboard(name: "Main", bundle: Bundle.main)
    }
    
    class func mapsStoryboard() -> UIStoryboard {
        return UIStoryboard(name: "Maps", bundle: Bundle.main)
    }
}
