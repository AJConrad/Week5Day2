//
//  ViewController.swift
//  SwiftyContact
//
//  Created by Andrew Conrad on 5/10/16.
//  Copyright © 2016 AndrewConrad. All rights reserved.
//

import UIKit
import CoreData
import ContactsUI

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, CNContactPickerDelegate, CNContactViewControllerDelegate {
    
    let contactStore = CNContactStore ()
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    var contactArray = [Contact]()
    
    var indexArray = [String]()
    var sectionArray = [String]()
    var lastNameLetterArray = [String]()
    
    @IBOutlet weak var          contactTableView :UITableView!

    //MARK: - Phone Contact Stuff
    
    @IBAction private func showContactsListView(sender: UIBarButtonItem) {
        let contactListVC = CNContactPickerViewController()
        contactListVC.delegate = self
        presentViewController(contactListVC, animated: true, completion: nil)
    }
    
    func contactPicker(picker: CNContactPickerViewController, didSelectContact contact: CNContact) {
        let entityDescription = NSEntityDescription.entityForName("Contact", inManagedObjectContext: managedObjectContext)
        let newContact = Contact(entity: entityDescription!, insertIntoManagedObjectContext: managedObjectContext)
            newContact.firstName = contact.givenName
            newContact.lastName = contact.familyName
        if  let email = contact.emailAddresses.first?.value as? String {
            newContact.emailAddress = email
        }
        if let address = contact.postalAddresses.first {
            let addressValue = address.value as! CNPostalAddress
            newContact.streetAddress = addressValue.street
            newContact.cityAddress = addressValue.city
            newContact.stateAddress = addressValue.state
            newContact.zipAddress = addressValue.postalCode
        }
        if let phone = contact.phoneNumbers.first?.value as? CNPhoneNumber {
            newContact.phoneNumber = phone.stringValue
        }
        newContact.rating = 0
        appDelegate.saveContext()
    }
    
    //MARK: - Core Data Methods
    
    func tempAddRecords() {
        let entityDescription = NSEntityDescription.entityForName("Contact", inManagedObjectContext: managedObjectContext)!
        let newContact = Contact(entity: entityDescription, insertIntoManagedObjectContext: managedObjectContext)
        newContact.firstName = "Bob"
        newContact.lastName = "Thorton"
        newContact.streetAddress = "123 Country Lane"
        newContact.cityAddress = "Podunk"
        newContact.stateAddress = "Alabama"
        newContact.zipAddress = "35010"
        newContact.phoneNumber = "123-456-7890"
        newContact.emailAddress = "duckExterminator@yahoo.com"
        newContact.rating = 3
        appDelegate.saveContext()
    }
    
    func fetchContact() -> [Contact]? {
        let fetchRequest = NSFetchRequest(entityName: "Contact")
        do {
            let tempArray = try managedObjectContext.executeFetchRequest(fetchRequest) as! [Contact]
            return tempArray
        } catch {
            return nil
        }
    }
    //MARK: - Segue Methods
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let destController = segue.destinationViewController as! DetailViewController
        if segue.identifier == "Edit" {
            let indexPath = contactTableView.indexPathForSelectedRow
            let selectedContact = contactArray[indexPath!.row]
            destController.selectedContact = selectedContact
            contactTableView.deselectRowAtIndexPath(indexPath!, animated: true)
        } else if segue.identifier == "Add" {
            destController.selectedContact = nil
        }
    }
    
    //MARK: - Core Sorting Methods
    
    private func createIndexFromArray(array: [Contact]) -> [String] {
        let lastNameArray = array.map {$0.lastName!}
        var uniqueArray = Array(Set(lastNameArray))
        uniqueArray.sortInPlace()
        return uniqueArray
    }
    
    private func createLettersIndexFromArray(array: [String]) -> [String] {
        let letterArray = array.map {String($0[$0.startIndex.advancedBy(0)])}
        var uniqueArray = Array(Set(letterArray))
        uniqueArray.sortInPlace()
        return uniqueArray
    }
    
    private func filterArrayForSection(array: [Contact], section: Int) -> [Contact] {
        let sectionHeader = indexArray[section]
        return array.filter {$0.lastName == sectionHeader}
    }
    
    
    //MARK: - Table View Methods
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return indexArray.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filterArrayForSection(contactArray, section: section).count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        let sectionArray = filterArrayForSection(contactArray, section: indexPath.section)
        let currentContact = sectionArray[indexPath.row]
//        let sectionArray = filterArrayForSection(peopleArray, section: indexPath.section)
//        let currentPerson = sectionArray[indexPath.row]
        cell.textLabel!.text = currentContact.firstName! + " " + currentContact.lastName!
        cell.detailTextLabel!.text = currentContact.phoneNumber!
        return cell
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return lastNameLetterArray[section]
    }
    //MARK: - NEED HELP HERE
    //
    //
    //
    //
    //I BROKE EVERYTHING WHEN I TRIED TO HAVE A SECOND NAME STARTING WITH THE SAME LETTER! IDK WHAT I DID!!!
    
    
    //MARK: - Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        tempAddRecords()


    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        contactArray = fetchContact()!
        contactArray.sortInPlace { (contact1: Contact, contact2: Contact) -> Bool in
            contact1.lastName < contact2.lastName
        }
        print(contactArray)
        contactTableView.reloadData()
        
        indexArray = createIndexFromArray(contactArray)
        print("\(indexArray)")
        lastNameLetterArray = createLettersIndexFromArray(indexArray)
        print("\(lastNameLetterArray)")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }


}

