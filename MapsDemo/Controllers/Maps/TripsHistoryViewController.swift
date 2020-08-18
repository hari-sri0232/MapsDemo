//
//  TripsHistoryViewController.swift
//  MapsDemo
//
//  Created by Sri Hari on 14/08/20.
//  Copyright © 2020 Ojas. All rights reserved.
//

import UIKit
import SwiftyXMLParser


class TripsHistoryViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    let coreDataManager = CoreDataManager.sharedInstance
    var trips: NSMutableArray?
    

    override func viewDidLoad() {
        super.viewDidLoad()
      // registerCells()
    }
    
//    func registerCells() {
//        self.tableView.register(HistoryTableViewCell.self, forCellReuseIdentifier: "HistoryTableViewCell")
//        self.tableView.register(UINib(nibName: "HistoryTableViewCell", bundle: .main), forHeaderFooterViewReuseIdentifier: "HistoryTableViewCell")
//    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if let results = coreDataManager.fetchEntityResults("Trips") {
            trips = NSMutableArray()
            trips?.addObjects(from: results)
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

}

extension TripsHistoryViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if trips?.count ?? 0 > 0 {
            return trips?.count ?? 0
        }else{
            return 0
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if trips?.count ?? 0 > 0 {
            return trips!.count
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "CusCell")
        if cell == nil {
            cell = UITableViewCell.init(style: .default, reuseIdentifier: "CusCell")
        }
        let rOne = cell?.contentView.viewWithTag(33) as? UILabel
        let rTwo = cell?.contentView.viewWithTag(34) as? UILabel
        let rThree = cell?.contentView.viewWithTag(35) as? UILabel
        let rFour = cell?.contentView.viewWithTag(36) as? UILabel
        let trip = trips?.object(at: indexPath.row) as? Trips
        let routes = NSKeyedUnarchiver.unarchiveObject(with: (trip?.routes)! as Data) as? NSArray
            let dic = routes?.object(at: 0) as? [String:Any]
            let legs = dic?["legs"] as? NSArray
            let insideLegdic = legs?.object(at: 0) as? [String:Any]
            let steps = insideLegdic?["steps"] as? NSArray
            for index in 0..<steps!.count {
                if steps!.count >= 4 {
                    let insideStepdic = steps?.object(at: index) as? [String:Any]
                    if index == 0 {
                        let str = insideStepdic?["html_instructions"] as? String
                        rOne?.text = str
                        //"\(String(describing: str))"
                    }else if index == 1 {
                        rTwo?.text = insideStepdic?["html_instructions"] as? String
                    }else if index == 2 {
                        rThree?.text = insideStepdic?["html_instructions"] as? String
                    }else if index == 3 {
                        rFour?.text = insideStepdic?["html_instructions"] as? String
                    }
                }
            }

        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = Bundle.main.loadNibNamed("CollapsingHeaderView", owner: self, options: nil)?[0] as! CollapsingHeaderView
         let trip = trips?.object(at: section) as? Trips
        let fullName = "\(trip?.sName ?? "") to \(trip?.dName ?? "")"
        header.sectionName.text = fullName
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 70
    }
    
    
}
