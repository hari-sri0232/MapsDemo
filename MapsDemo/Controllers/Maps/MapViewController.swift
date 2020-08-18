//
//  MapViewController.swift
//  MapsDemo
//
//  Created by Sri Hari on 14/08/20.
//  Copyright © 2020 Ojas. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import CoreLocation
import SwiftyJSON
import Polyline
import CoreData

class MapViewController: UIViewController {
    @IBOutlet weak var mapBaseView: GMSMapView!
    @IBOutlet weak var BookingView: UIView!
    @IBOutlet weak var souceTextField: UITextField!
    @IBOutlet weak var destinationTextField: UITextField!
    
    @IBOutlet weak var bookingViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var startRideButton: UIButton!
    
    
    var mapViewModel = MapViewModel()
    public var sourcePlace:GMSPlace? = nil
    public var destinationPlace:GMSPlace? = nil
    var routesArray:NSArray?
    var locationManager = CLLocationManager()
    var movingMarker:GMSMarker?
    var stepsCoords:[CLLocationCoordinate2D] = []
    var iPosition:Int = 0;
    var timer = Timer()
    
    let coreDataManager = CoreDataManager.sharedInstance
    let activityIndidcator = ActivityIndicator.sharedInstance
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpRigthBarButtonItem()
        setUpInitialParameters()
        initializeTheLocationManager()
        self.mapBaseView.delegate = self
        self.mapBaseView.isMyLocationEnabled = true
        self.mapBaseView.setMinZoom(6.0, maxZoom: 20.0)
    }
    func initializeTheLocationManager() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func setUpRigthBarButtonItem() {
        let addTripButton = UIBarButtonItem.init(barButtonSystemItem: .add, target: self, action: #selector(newBookingTapped))
        self.navigationItem.rightBarButtonItem = addTripButton
    }
    func setUpInitialParameters() {
        Helper.renderSubViews(view: self.startRideButton, cornerRadius: 5.0, borderColor: UIColor(), borderWidth: 0.0)
    }
    
    @objc func newBookingTapped() {
        UIView.animate(withDuration: 1.0) {
            self.bookingViewHeightConstraint.constant = 190.0
            self.BookingView.isHidden = false
            self.BookingView.layoutIfNeeded()
            self.souceTextField.text = ""
            self.destinationTextField.text = ""
            self.sourcePlace = nil
            self.destinationPlace = nil
            self.mapBaseView.clear()
        }
    }
    
    func drawRouteBetweenTwoLocations(routesObj: [String:Any]) {
        self.locationManager.stopUpdatingLocation()
        self.locationManager.delegate = nil
        let routes = routesObj["routes"] as! NSArray
        self.routesArray = routes
        for index in 0..<routes.count {
            let route = routes.object(at: index) as? [String:Any]
            let overview_polyline = route?["overview_polyline"] as? [String:Any]
            let points = overview_polyline?["points"] as? String
            let path = GMSPath(fromEncodedPath: points ?? "")
            let polyLine = GMSPolyline.init(path: path)
            polyLine.strokeColor = .systemBlue
            polyLine.strokeWidth = 5
            polyLine.map = self.mapBaseView
        }
        
        let sourceMarker = GMSMarker()
        sourceMarker.position = CLLocationCoordinate2D(latitude: (sourcePlace?.coordinate.latitude)!, longitude: (sourcePlace?.coordinate.longitude)!)
        sourceMarker.title = sourcePlace?.name
        sourceMarker.snippet = sourcePlace?.formattedAddress
        sourceMarker.map = self.mapBaseView
        
        let destinationMarker = GMSMarker()
        destinationMarker.position = CLLocationCoordinate2D(latitude: (destinationPlace?.coordinate.latitude)!, longitude: (destinationPlace?.coordinate.longitude)!)
        destinationMarker.title = destinationPlace?.name
        destinationMarker.snippet = destinationPlace?.formattedAddress
        destinationMarker.map = self.mapBaseView
        
        self.mapBaseView.camera = GMSCameraPosition.camera(withTarget: sourceMarker.position, zoom: 13)
        self.movingMarker = GMSMarker()
        self.movingMarker?.groundAnchor = CGPoint(x: CGFloat(0.5), y: CGFloat(0.5))
        self.movingMarker?.icon = UIImage(named: "MovingMarker")
        self.movingMarker?.position = sourceMarker.position
        self.movingMarker?.map = self.mapBaseView
        let route = routes.object(at: 0) as? [String:Any]
        let overview_polyline = route?["overview_polyline"] as? [String:Any]
        self.stepsCoords = decodePolyline(overview_polyline?["points"] as! String)!
        self.timer = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true, block: { (_) in
            self.playAnimation()
        })
        
        RunLoop.current.add(self.timer, forMode: RunLoop.Mode.common)
    }
    
    func playAnimation(){
           if iPosition <= self.stepsCoords.count - 1 {
               let position = self.stepsCoords[iPosition]
               self.movingMarker?.position = position
                mapBaseView.camera = GMSCameraPosition(target: position, zoom: 15, bearing: 0, viewingAngle: 0)
               self.movingMarker!.groundAnchor = CGPoint(x: CGFloat(0.5), y: CGFloat(0.5))
               if iPosition != self.stepsCoords.count - 1 {
                   self.movingMarker!.rotation = CLLocationDegrees(exactly: self.getHeadingForDirection(fromCoordinate: self.stepsCoords[iPosition], toCoordinate: self.stepsCoords[iPosition+1]))!
               }
               
               if iPosition == self.stepsCoords.count - 1 {
                   iPosition = 0;
                   timer.invalidate()
                showAlertForEndTrip()
               }
               
               iPosition += 1
           }
           
       }
    
    func getHeadingForDirection(fromCoordinate fromLoc: CLLocationCoordinate2D, toCoordinate toLoc: CLLocationCoordinate2D) -> Float {
        
        let fLat: Float = Float((fromLoc.latitude).degreesToRadians)
        let fLng: Float = Float((fromLoc.longitude).degreesToRadians)
        let tLat: Float = Float((toLoc.latitude).degreesToRadians)
        let tLng: Float = Float((toLoc.longitude).degreesToRadians)
        let degree: Float = (atan2(sin(tLng - fLng) * cos(tLat), cos(fLat) * sin(tLat) - sin(fLat) * cos(tLat) * cos(tLng - fLng))).radiansToDegrees
        if degree >= 0 {
            return degree - 180.0
        }
        else {
            return (360 + degree) - 180
        }
    }
        
        func showAlertForEndTrip() {
            let alertController = UIAlertController.init(title: "Reached Destination", message: "Would you like to end the trip..", preferredStyle: .alert)
            let endTrip = UIAlertAction.init(title: "End Trip", style: .default) { (action) in
                self.updateCoreDataStackWithTripInfo()
            }
            alertController.addAction(endTrip)
            self.present(alertController, animated: true, completion: nil)
        }
    
    func updateCoreDataStackWithTripInfo() {
        coreDataManager.updateTripData(sourec: sourcePlace!, destination: destinationPlace!, routes: routesArray ?? NSArray())
        clearMapValues()
    }
    
    func clearMapValues() {
        self.souceTextField.text = ""
        self.destinationTextField.text = ""
        self.sourcePlace = nil
        self.destinationPlace = nil
        self.mapBaseView.clear()
    }

    @IBAction func startRiding(_ sender: Any) {
        guard let sPlace = sourcePlace else {
            Helper.showAlert(title: "Please Choose Starting Location", message: "")
            return
        }
        guard let dPlace = destinationPlace else {
            Helper.showAlert(title: "Please Choose Destination", message: "")
            return
        }
        activityIndidcator?.addToView(baseView: self.view, postion: .center)
        activityIndidcator?.startAnimating()
        mapViewModel.getRoutes(sourcePlace: sPlace, destinationPlace: dPlace) { (routesArray, message) in
            self.activityIndidcator?.stopAnimating()
            switch message {
            case .error(desc: let msg):
                print(msg)
            case .success:
                self.drawRouteBetweenTwoLocations(routesObj: routesArray!)
                UIView.animate(withDuration: 1.0) {
                    self.bookingViewHeightConstraint.constant = 0.0
                    self.BookingView.isHidden = true
                    self.BookingView.layoutIfNeeded()
                }
            case .none:
                print("")
            case .some(_):
                print("")
            }
        }
    }
    
    func navigateToSearch(isComingFrom: String) {
        let searchVC = StoryboardManager.mapsStoryboard().instantiateViewController(identifier: "SearchLocationViewController") as? SearchLocationViewController
        searchVC?.hidesBottomBarWhenPushed = true
        searchVC?.isComingFrom = isComingFrom
        searchVC?.searchDelegate = self
        self.navigationController?.pushViewController(searchVC!, animated: true)
    }
}

extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
        cameraMoveToLocation(toLocation: location?.coordinate)

    }

    func cameraMoveToLocation(toLocation: CLLocationCoordinate2D?) {
        if toLocation != nil {
            mapBaseView.camera = GMSCameraPosition.camera(withTarget: toLocation!, zoom: 15)
           // self.locationManager.stopUpdatingLocation()

        }
    }
}

extension MapViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == souceTextField {
            navigateToSearch(isComingFrom: "Source")
        }else {
            navigateToSearch(isComingFrom: "Destination")
        }
        textField.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
}

extension MapViewController: SearchPlaces {
    func getSearchPlace(place: GMSPlace, isComingFrom: String) {
        if isComingFrom == "Source" {
            self.souceTextField.text = place.formattedAddress
            self.sourcePlace = place
        }else {
            self.destinationTextField.text = place.formattedAddress
            self.destinationPlace = place
        }
    }
    
    
}

extension MapViewController: GMSMapViewDelegate {
    
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        mapBaseView.animate(to: position)
    }
}

extension Int {
    var degreesToRadians: Double { return Double(self) * .pi / 180 }
}
extension FloatingPoint {
    var degreesToRadians: Self { return self * .pi / 180 }
    var radiansToDegrees: Self { return self * 180 / .pi }
}
