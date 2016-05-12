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
    
    @IBOutlet   weak    private     var            firstNameField:      UITextField!
    @IBOutlet   weak    private     var             lastNameField:      UITextField!
    @IBOutlet   weak    private     var        streetAddressField:      UITextField!
    @IBOutlet   weak    private     var          cityAddressField:      UITextField!
    @IBOutlet   weak    private     var         stateAddressField:      UITextField!
    @IBOutlet   weak    private     var              zipCodeField:      UITextField!
    @IBOutlet   weak    private     var          phoneNumberField:      UITextField!
    @IBOutlet   weak    private     var         emailAddressField:      UITextField!
    @IBOutlet   weak    private     var                   navItem:      UINavigationItem!
    @IBOutlet   weak    private     var           ratingStackView:      UIStackView!
    
    //MARK: - Stack View Methods
    
    func addRatingStars () {
        let starImageView = UIImageView(image: UIImage(named: "IconStar"))
        starImageView.contentMode = .ScaleAspectFit
        let starCount = ratingStackView.arrangedSubviews.count
        if starCount < 6 {
            ratingStackView.insertArrangedSubview(starImageView, atIndex: starCount - 1)
            UIView.animateWithDuration(0.5) { () -> Void in
                self.ratingStackView.layoutIfNeeded()
            }
        }
        
    }
    
    @IBAction   private     func    plusRatingButtonPressed(sender: UIButton) {
        self.addRatingStars()
    }
    
    @IBAction   private     func    minusRatingButtonPressed(sender: UIButton) {
        let starCount = ratingStackView.arrangedSubviews.count
        if starCount > 1 {
            let starToRemove = ratingStackView.arrangedSubviews[starCount - 2]
            ratingStackView.removeArrangedSubview(starToRemove)
            starToRemove.removeFromSuperview()
            //Try to figure out how to sync animation later
            UIView.animateWithDuration(0.5) {  () -> Void in
                self.ratingStackView.layoutIfNeeded()
            }
        }
        
    }
    
    //MARK: - Interactivity Methods
    
    @IBAction       func        nameChanged(textField: UITextField) {
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
        //without the -1, it never goes below 3 and it doesnt save right
        if ratingStackView.arrangedSubviews.count > 1 {
            selectedContact?.rating = ratingStackView.arrangedSubviews.count - 1
        } else {
            selectedContact?.rating = 0
        }

        appDelegate.saveContext()
        self.navigationController?.popViewControllerAnimated(true)
        
    }
    
    @IBAction       func        deleteButtonPressed(sender : UIBarButtonItem) {
        
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
            
            //is this whole line still needed?
            let rating :Int32 = selectedContact!.rating!.intValue
            
            switch rating {
            case 0:
                print("No Rating")
            case 1:
                self.addRatingStars()
                print("Rating 1")
            case 2:
                self.addRatingStars()
                self.addRatingStars()
                print("Rating 2")
            case 3:
                self.addRatingStars()
                self.addRatingStars()
                self.addRatingStars()
                print("Rating 3")
            case 4:
                self.addRatingStars()
                self.addRatingStars()
                self.addRatingStars()
                self.addRatingStars()
                print("Rating 4")
            case 5:
                self.addRatingStars()
                self.addRatingStars()
                self.addRatingStars()
                self.addRatingStars()
                self.addRatingStars()
                print("Rating 5")
            default:
                print("Rating cannot be above 5 or below 0")
            }
            
            
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
