//
//  FirstViewController.swift
//  SafeWalk
//
//  Created by Byron Mitchell on 12/11/19.
//  Copyright © 2019 Byron Mitchell. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {

    @IBOutlet weak var NameField: UITextField!
    @IBOutlet weak var LastNameField: UITextField!
    @IBOutlet weak var AddressField: UITextField!
    
    let defaults = UserDefaults.standard
    
    struct Keys {
        static let name = "Name"
        static let lastname = "Last Name"
        static let address = "Address"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        checkForSavedName()
        checkForSavedLastName()
        checkForSavedAddress()
        saveNamePreference()
        saveLastNamePreference()
        saveAddressPreference()
    }

    @IBAction func SavePressed(_ sender: Any) {
        saveNamePreference()
        saveLastNamePreference()
        saveAddressPreference()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        NameField.resignFirstResponder()
        LastNameField.resignFirstResponder()
        AddressField.resignFirstResponder()
    }
    
    func saveNamePreference(){
        defaults.set(NameField.text!, forKey: Keys.name)
    }
    
    func saveLastNamePreference(){
        defaults.set(LastNameField.text!, forKey: Keys.lastname)
    }
    
    func saveAddressPreference(){
        defaults.set(AddressField.text!, forKey: Keys.address)
    }
    
    func checkForSavedName(){
        let name = defaults.value(forKey: Keys.name)as? String ?? ""
        NameField.text = name
    }
    
    func checkForSavedLastName(){
        let lastname = defaults.value(forKey: Keys.lastname)as?
        String ?? ""
        LastNameField.text = lastname
    }
    
    func checkForSavedAddress(){
        let address = defaults.value(forKey: Keys.address)as? String ?? ""
        AddressField.text = address
    }
    
    
    @IBOutlet weak var Contactingauthorities: UITextField!
    @IBAction func HelpButtonPressed(_ sender: Any) {
        Contactingauthorities.isHidden = false
        }
    
    
}
    

