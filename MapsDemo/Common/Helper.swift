//
//  Helper.swift
//  MapsDemo
//
//  Created by Sri Hari on 13/08/20.
//  Copyright © 2020 Ojas. All rights reserved.
//

import Foundation
import UIKit

class Helper {
    
    class func renderSubViews(view: UIView, cornerRadius:CGFloat, borderColor:UIColor, borderWidth:CGFloat) {
        view.layer.borderWidth = borderWidth
        view.layer.cornerRadius = cornerRadius
        view.layer.masksToBounds = true
    }
    
    class func showAlert(title: String?, message: String?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let Okaction = UIAlertAction.init(title: "OK", style: .default, handler: nil)
        alertController.addAction(Okaction)
        UIApplication.shared.windows[0].rootViewController?.present(alertController, animated: true, completion: nil)
    }
    
    
}
