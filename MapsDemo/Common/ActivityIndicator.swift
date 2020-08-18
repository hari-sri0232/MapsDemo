//
//  ActivityIndicator.swift
//  EngineeringAiTask
//
//  Created by Sri Hari on 06/03/20.
//  Copyright © 2020 Ojas. All rights reserved.
//

import UIKit

class ActivityIndicator: UIActivityIndicatorView {

    static let sharedInstance: ActivityIndicator? = {
        let shared = ActivityIndicator()
        return shared
    }()
    func addToView(baseView: UIView, postion: IndicatorPosition) {
        if baseView.subviews.contains(self) {
            self.removeFromSuperview()
        }
        self.color = .darkGray
        switch postion {
        case .center:
            self.center = baseView.center
        case .bottom:
            self.frame = CGRect.init(x: baseView.frame.size.width/2 - 25, y: baseView.frame.size.height , width: 50, height: 50)
        case .top:
             self.frame = CGRect.init(x: baseView.frame.size.width/2 - 25, y: 0 , width: 50, height: 50)
        }
        baseView.addSubview(self)
    }

}
