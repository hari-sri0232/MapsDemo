//
//  CoreDataManager.swift
//  MapsDemo
//
//  Created by Sri Hari on 17/08/20.
//  Copyright © 2020 Ojas. All rights reserved.
//

import UIKit
import CoreData
import GooglePlaces

class CoreDataManager: NSObject {
    
    static let sharedInstance = CoreDataManager()
    
    let appDel = UIApplication.shared.delegate as! AppDelegate
    
    public var profile:UserProfile {
        var profileObj:UserProfile?
        var resultArray: [Any]? = nil
        resultArray = self.fetchEntityResults("UserProfile")
        if let rArr = resultArray{
            if rArr.count > 0{
                profileObj = (rArr.first as? UserProfile)!
            }else{
                let context = appDel.persistentContainer.viewContext
                 let entity = NSEntityDescription.entity(forEntityName: "UserProfile", in: context)
                profileObj = UserProfile(entity: entity!, insertInto: context)
            }
        }
        return profileObj!
    }
    
    func fetchEntityResults(_ entity: String?) -> [Any]? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity!)
        var resultArray: [Any]? = nil
        do {
            let context = appDel.persistentContainer.viewContext
            resultArray = try context.fetch(fetchRequest)
        } catch {
        }
        return resultArray
    }

    func saveContext() {
        let context = appDel.persistentContainer.viewContext
       do {
           try context.save()
          } catch {
           print("Failed saving")
        }
    }
    
    func fetchCompletedResults() -> NSMutableArray {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Trips")
        request.predicate = NSPredicate(format: "isTripEnded = %@", true)
        request.returnsObjectsAsFaults = false
        let context = appDel.persistentContainer.viewContext
        var resultsArray:NSMutableArray? = nil
        
        do {
            let result = try context.fetch(request)
            resultsArray = result as? NSMutableArray
        } catch {
            print("Failed")
        }
        return resultsArray ?? NSMutableArray()
    }
    
    func updateTripData(sourec: GMSPlace, destination: GMSPlace, routes: NSArray) {
         let context = appDel.persistentContainer.viewContext
        let resultArray = self.fetchEntityResults("UserProfile")! as NSArray
        var profile:UserProfile?
        if  resultArray.count > 0 {
            profile = resultArray.firstObject as? UserProfile
        }else{
            let entityDesc = NSEntityDescription.entity(forEntityName: "UserProfile", in: context)
            profile = UserProfile.init(entity: entityDesc!, insertInto: context)
        }
        let tripEntity = NSEntityDescription.entity(forEntityName: "Trips", in: context)
        let trip = NSManagedObject(entity: tripEntity!, insertInto: context) as? Trips
        trip?.sName = sourec.name
        trip?.sLat = sourec.coordinate.latitude
        trip?.sLong = sourec.coordinate.longitude
        trip?.sAddress = sourec.formattedAddress
        trip?.dName = destination.name
        trip?.dLat = destination.coordinate.latitude
        trip?.dLong = destination.coordinate.longitude
        trip?.dAddress = destination.formattedAddress
        let routesData = NSKeyedArchiver.archivedData(withRootObject: routes) as NSData
        trip?.routes = routesData as Data
        trip?.isTripEnded = true
        profile?.addToTrips(trip!)
        self.saveContext()
    }
}
