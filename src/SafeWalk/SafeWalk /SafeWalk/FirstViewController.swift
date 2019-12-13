//
//  FirstViewController.swift
//  SafeWalk
//
//  Created by Byron Mitchell on 12/11/19.
//  Copyright © 2019 Byron Mitchell. All rights reserved.
//

import UIKit
import MessageUI


class FirstViewController: UIViewController, MFMessageComposeViewControllerDelegate {
    
    

    @IBOutlet weak var NameField: UITextField!
    @IBOutlet weak var LastNameField: UITextField!
    @IBOutlet weak var AddressField: UITextField!
    
    let defaults = UserDefaults.standard
    
    struct Keys {
        static let name = "Name"
        static let lastname = "Last Name"
        static let address = "Address"
        static let phoneNumber = 7873793060;

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
        displayMessageInterface()
        }
    
    func displayMessageInterface() {
        let composeVC = MFMessageComposeViewController()
        composeVC.messageComposeDelegate = self
        
        // Configure the fields of the interface.
        composeVC.recipients = ["7873793060"]
        composeVC.body = "Message sent using the SafeWalk app: It's  \(String(describing: NameField.text))\(String(describing: LastNameField.text)), I am walking back home and I don't feel safe"
        
        // Present the view controller modally.
        if MFMessageComposeViewController.canSendText() {
            self.present(composeVC, animated: true, completion: nil)
        } else {
            print("Can't send messages.")
        }
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
    }
}
    

