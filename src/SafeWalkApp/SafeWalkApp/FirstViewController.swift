//
//  FirstViewController.swift
//  SafeWalkApp
//
//  Created by Samantha Puterman on 12/7/19.
//  Copyright © 2019 Samantha Puterman. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {

    @IBOutlet weak var NameField: UITextField!
    @IBOutlet weak var LastNameField: UITextField!
    @IBOutlet weak var AddressField: UITextField!
    @IBOutlet weak var TextView: UITextView!
    
    let defaults = UserDefaults.standard
    
    struct Keys {
        static let name = "Name"
        static let lastname = "Last Name"
        static let address = "Address"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       // NameField.delegate = self
        checkForSavedName()
        checkForSavedLastName()
        checkForSavedAddress()
        saveNamePreference()
        saveLastNamePreference()
        saveAddressPreference()
       // LastNameField.delegate = self
       // AddressField.delegate = self
        // Do any additional setup after loading the view.
        
    }


    @IBAction func EnterPressed(_ sender: Any) {
       // TextView.text = "Name: \(NameField.text!)\n LastName: \(LastNameField.text!)\n Address:\(AddressField.text!)\n"
        
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
       // defaults.set(LastNameField, forKey: Keys.lastname)
    }
    
    func saveLastNamePreference(){
        defaults.set(LastNameField.text!, forKey: Keys.lastname)
    }
    
    func saveAddressPreference(){
        defaults.set(AddressField.text!, forKey: Keys.address)
    }
    
    func checkForSavedName() {
        let name = defaults.value(forKey: Keys.name)as? String ?? ""
        NameField.text = name
    }
    
    func checkForSavedLastName(){
        let lastname = defaults.value(forKey: Keys.lastname)as? String ?? ""
        LastNameField.text = lastname
    }
    
    func checkForSavedAddress(){
        let address = defaults.value(forKey: Keys.address)as? String ?? ""
        AddressField.text = address
    }
    
    
    }
/*extension FirstViewController : UITextFieldDelegate {
    func textFieldShouldReturn( _ textField: UITextField)->Bool {
    textField.resignFirstResponder()
    return true*/
//}
//}

