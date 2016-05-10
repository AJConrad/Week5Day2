//
//  DetailViewController.swift
//  SwiftyContact
//
//  Created by Andrew Conrad on 5/10/16.
//  Copyright © 2016 AndrewConrad. All rights reserved.
//

import UIKit
import CoreData

class DetailViewController: UIViewController {
    
    var selectedContact :Contact?
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    @IBOutlet   weak    var            firstNameField:      UITextField!
    @IBOutlet   weak    var             lastNameField:      UITextField!
    @IBOutlet   weak    var        streetAddressField:      UITextField!
    @IBOutlet   weak    var          cityAddressField:      UITextField!
    @IBOutlet   weak    var         stateAddressField:      UITextField!
    @IBOutlet   weak    var              zipCodeField:      UITextField!
    @IBOutlet   weak    var          phoneNumberField:      UITextField!
    @IBOutlet   weak    var         emailAddressField:      UITextField!
    @IBOutlet   weak    var                   navItem:      UINavigationItem!
    
    //MARK: - Interactivity Methods
    
    @IBAction       func        nameChanged(textField: UITextField) {
        print("Name Change")
        navItem.title = firstNameField.text! + " " + lastNameField.text!
    }
    
    @IBAction       func        saveButtonPressed(sender : UIBarButtonItem) {
        
        if firstNameField.text == nil {
            firstNameField.text = ""
            selectedContact?.firstName = firstNameField.text
        } else {
            selectedContact?.firstName = firstNameField.text
        }
        
        if lastNameField.text == nil {
            lastNameField.text = ""
            selectedContact?.lastName = lastNameField.text
        } else {
            selectedContact?.lastName = lastNameField.text
        }
        
        if streetAddressField.text == nil {
            streetAddressField.text = ""
            selectedContact?.streetAddress = streetAddressField.text
        } else {
            selectedContact?.streetAddress = streetAddressField.text
        }
        
        if cityAddressField.text == nil {
            cityAddressField.text = ""
            selectedContact?.cityAddress = cityAddressField.text
        } else {
            selectedContact?.cityAddress = cityAddressField.text
        }
        
        if stateAddressField.text == nil {
            stateAddressField.text = ""
            selectedContact?.stateAddress = stateAddressField.text
        } else {
            selectedContact?.stateAddress = stateAddressField.text
        }
        
        if zipCodeField.text == nil {
            zipCodeField.text = ""
            selectedContact?.zipAddress = zipCodeField.text
        } else {
            selectedContact?.zipAddress = zipCodeField.text
        }
        
        if phoneNumberField.text == nil {
            phoneNumberField.text = ""
            selectedContact?.phoneNumber = phoneNumberField.text
        } else {
            selectedContact?.phoneNumber = phoneNumberField.text
        }
        
        if emailAddressField.text == nil {
            emailAddressField.text = ""
            selectedContact?.emailAddress = emailAddressField.text
        } else {
            selectedContact?.emailAddress = emailAddressField.text
        }
        
        appDelegate.saveContext()
        self.navigationController?.popViewControllerAnimated(true)
        
    }
    
    @IBAction       func        deleteButtonPressed(sender : UIBarButtonItem) {
//        [_managedObjectContext deleteObject:_currentAssignment];
//        [self saveAndPop];

        managedObjectContext.deleteObject(selectedContact!)
        appDelegate.saveContext()
        self.navigationController?.popViewControllerAnimated(true)
        
    }
    
    //MARK: - Life Cycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()

        if selectedContact != nil {
            firstNameField.text = selectedContact?.firstName
            lastNameField.text = selectedContact?.lastName
            streetAddressField.text = selectedContact?.streetAddress
            cityAddressField.text = selectedContact?.cityAddress
            stateAddressField.text = selectedContact?.stateAddress
            zipCodeField.text = selectedContact?.zipAddress
            phoneNumberField.text = selectedContact?.phoneNumber
            emailAddressField.text = selectedContact?.emailAddress
            self.title = (selectedContact?.firstName)! + " " + (selectedContact?.lastName)!
            
        } else {
            let entityDescription = NSEntityDescription.entityForName("Contact", inManagedObjectContext: managedObjectContext)!
            selectedContact = Contact(entity: entityDescription, insertIntoManagedObjectContext: managedObjectContext)
            firstNameField.text = ""
            lastNameField.text = ""
            streetAddressField.text = ""
            cityAddressField.text = ""
            stateAddressField.text = ""
            zipCodeField.text = ""
            phoneNumberField.text = ""
            emailAddressField.text = ""
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        if managedObjectContext.hasChanges {
            managedObjectContext.rollback()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
