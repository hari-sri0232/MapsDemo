//
//  CollapsingHeaderView.swift
//  MapsDemo
//
//  Created by Sri Hari on 17/08/20.
//  Copyright © 2020 Ojas. All rights reserved.
//

import UIKit

class CollapsingHeaderView: UIView {

    @IBOutlet weak var sectionName: UILabel!
    @IBOutlet weak var collapseButton: UIButton!
    
    class func headerView() -> CollapsingHeaderView {
        let header = Bundle.main.loadNibNamed("CollapsingHeaderView", owner: self, options: nil)?[0] as! CollapsingHeaderView
        return header
    }
    
}
