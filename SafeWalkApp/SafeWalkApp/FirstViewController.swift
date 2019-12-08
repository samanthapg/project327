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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NameField.delegate = self
        LastNameField.delegate = self
        AddressField.delegate = self
        // Do any additional setup after loading the view.
        
        
    }


    @IBAction func EnterPressed(_ sender: Any) {
        TextView.text = "Name: \(NameField.text!)\n LastName: \(LastNameField.text!)\n Address:\(AddressField.text!)\n"
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        NameField.resignFirstResponder()
        LastNameField.resignFirstResponder()
        AddressField.resignFirstResponder()

    }
    
    }
extension FirstViewController : UITextFieldDelegate {
    func textFieldShouldReturn( _ textField: UITextField)->Bool {
    textField.resignFirstResponder()
    return true
}
}

