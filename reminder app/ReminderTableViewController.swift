//
//  ReminderTableViewController.swift
//  reminder app
//
//  Created by Brett Karpinos on 10/19/16.
//
//

import UIKit

class ReminderTableViewController: UITableViewController {
    
    //MARK: Properties
    
    var reminders = [Reminder]()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load the sample data.
        loadSampleReminders()
    }
    
    func loadSampleReminders() {

        let reminder1 = Reminder(name: "EECS481: Finish Alpha", date: "Oct-20")!
        let reminder2 = Reminder(name: "TC497: SRS ", date: "Oct-21")!
        
        reminders += [reminder1, reminder2]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return reminders.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "ReminderTableViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! ReminderTableViewCell
        
        // Fetches the appropriate meal for the data source layout.
        let reminder = reminders[indexPath.row]

        // Configure the cell...
        cell.nameLabel.text = reminder.name
        cell.dateLabel.text = reminder.date



        return cell
    }
    



    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func unwindToReminderList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? ReminderViewController, let reminder = sourceViewController.reminder {
            // Add a new meal.
            let newIndexPath = IndexPath(row: reminders.count, section: 0)
            reminders.append(reminder)
            tableView.insertRows(at: [newIndexPath], with: .bottom)
        }
    }

}