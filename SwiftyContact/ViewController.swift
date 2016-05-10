//
//  ViewController.swift
//  SwiftyContact
//
//  Created by Andrew Conrad on 5/10/16.
//  Copyright © 2016 AndrewConrad. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    var contactArray = [Contact]()
    @IBOutlet weak var          contactTableView :UITableView!
    
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
    
    //MARK: - Interactivity Methods
    
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
    
    
//    if ([[segue identifier] isEqualToString:@"editAssignmentSegue"]) {
//    NSIndexPath *indexPath = [_assignmentsTable indexPathForSelectedRow];
//    Assignment *selectedAssignment = _assignmentsArray [indexPath.row];
//    destController.currentAssignment = selectedAssignment;
//    } else if ([[segue identifier] isEqualToString:@"addAssignmentSegue"]) {
//    destController.currentAssignment = nil;
    
    
    //MARK: - Table View Methods
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contactArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        let currentContact = contactArray[indexPath.row]
        cell.textLabel!.text = currentContact.firstName! + " " + currentContact.lastName!
        cell.detailTextLabel!.text = currentContact.phoneNumber!
        return cell
    }
    
    //MARK: - Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        tempAddRecords()


    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        contactArray = fetchContact()!
        contactTableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }


}

