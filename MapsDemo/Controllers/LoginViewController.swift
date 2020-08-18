//
//  LoginViewController.swift
//  MapsDemo
//
//  Created by Sri Hari on 13/08/20.
//  Copyright © 2020 Ojas. All rights reserved.
//

import UIKit
import CoreData

class LoginViewController: UIViewController {
    // Outlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordtextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    var tabBar:MapsTabBarController? = nil
    let appDel = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpInitialParameters()
        loginCheck()
    }
    
    func setUpInitialParameters() {
        Helper.renderSubViews(view: self.loginButton, cornerRadius: 5.0, borderColor: UIColor(), borderWidth: 0.0)
        self.emailTextField.text = "harisri0232@gmail.com"  //Temporery check. Remove while in development
        self.passwordtextField.text = "12345"
    }
    
    func loginCheck() {
        if let loginCheck = UserDefaults.standard.value(forKeyPath: "LoginSucceded") as? Bool {
            if loginCheck {
                tabBar = MapsTabBarController()
                tabBar?.delegate = self
                self.view.addSubview(tabBar?.view ?? UIView())
            }
        }
    }
    

   //MARK: Action Methods
    @IBAction func loggingIn(_ sender: Any) {
        UserDefaults.standard.set(true, forKey: "LoginSucceded")
        UserDefaults.standard.synchronize()
        saveLoginInfo()
        launchTabBar()
    }
    
}

extension LoginViewController {
    
    func launchTabBar() {
        let tabBar = MapsTabBarController()
        self.view.window?.rootViewController = tabBar
    }
    
    func saveLoginInfo() {
        let context = appDel.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "UserProfile", in: context)
        let profile = NSManagedObject(entity: entity!, insertInto: context) as? UserProfile
        profile?.email = emailTextField.text
        profile?.password = passwordtextField.text
        CoreDataManager.sharedInstance.saveContext()
    }
}

extension LoginViewController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        switch viewController {
        case is MapViewController:
            tabBar?.selectedIndex = 0
        case is TripsHistoryViewController:
            tabBar?.selectedIndex = 1
        default:
            print("")
        }
    }
}
