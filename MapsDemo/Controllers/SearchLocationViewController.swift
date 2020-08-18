//
//  SearchLocationViewController.swift
//  MapsDemo
//
//  Created by Sri Hari on 14/08/20.
//  Copyright © 2020 Ojas. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import GooglePlaces


protocol SearchPlaces {
    func getSearchPlace(place: GMSPlace, isComingFrom: String)
}

class SearchLocationViewController: UIViewController {
    
    var searchDelegate:SearchPlaces?
    public var isComingFrom:String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presentPlacesVC()
    }
    
    func presentPlacesVC() {
        let placesController = GMSAutocompleteViewController()
        placesController.delegate = self
        present(placesController, animated: true, completion: nil)
    }

}

extension SearchLocationViewController: GMSAutocompleteViewControllerDelegate {
  func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
    print(place)
    searchDelegate?.getSearchPlace(place: place, isComingFrom: isComingFrom ?? "")
    dismiss(animated: true, completion: nil)
    self.navigationController?.popViewController(animated: true)
  }

func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {

    print("Error: ", error.localizedDescription)
  }

func wasCancelled(_ viewController: GMSAutocompleteViewController) {
    dismiss(animated: true, completion: nil)
    self.navigationController?.popViewController(animated: true)

  }
}
