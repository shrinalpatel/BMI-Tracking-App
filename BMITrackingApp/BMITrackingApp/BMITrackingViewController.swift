//
//  BMITrcakingViewController.swift
//  BMITrackingApp
//
//  Created by Shrinal Patel on 17/12/21.
//  Final Exam for MAPD714 - iOS Development
//  Description: This is a simple BMI Calculator app to calculate BMI In both Standard and Imperial units. It also supports persistant data storage.

import UIKit
import CoreData

class BMITrackingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // Implementing Core Data
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var weight: String?
    var bmi: String?
    var date: String?
    var name: String?
    
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    var bmiRecords = [BMIRecords]()
    var firstLoad = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        // Registering nib uitableview cell
        
        tableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "TableViewCell")
        userLabel.text = "Hello " + name! + "!"
        
        // To load the View Controller for the first time
        
        if(firstLoad)
                {
                    firstLoad = false
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
                    let request = NSFetchRequest<NSFetchRequestResult>(entityName: "BMIRecords")
                    do {
                        let results:NSArray = try context.fetch(request) as NSArray
                        for result in results
                        {
                            let record = result as! BMIRecords
                            bmiRecords.append(record)
                        }
                    }
                    catch
                    {
                        print("Fetch Failed")
                    }
                }
    }
    
    // Changing height of the nib cell
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 78
    }
    
    // Methof for number of cells in table view
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(bmiRecords.count == 0){
            _ = navigationController?.popToRootViewController(animated: false)
            
        }
        return bmiRecords.count
    }
    
    // Method to add a new BMI Record
    
    @IBAction func addNewRecordTap(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        
        self.navigationController?.pushViewController(vc , animated: true)
    }
    
    // Method for fetching values for all the labels of each cell
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let selectedBMIRecord = bmiRecords[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
        cell.weightLabel.text = "Weight: " + String(selectedBMIRecord.weight)
        cell.BMIResultLabel.text = "BMI: " + String(selectedBMIRecord.bmi)
        let date =  Date()
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .none
        dateFormatter.dateStyle = .long
        cell.dateLabel.text = "Date: \(dateFormatter.string(from: date))"
    
        return cell
    }
    
    // Gesture Control for editing a BMI record
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let record = bmiRecords[indexPath.row]
        
        let editAction = UIContextualAction(style: .normal, title: "Edit") { _,_,_ in
            
            let alert = UIAlertController(title: "Edit", message: "Edit BMI Record", preferredStyle : .alert)
            alert.addTextField(configurationHandler:  nil)
            alert.textFields?.first?.text = String(record.weight)
            let strWeight: String = String(record.weight)
            let thisWeight : Float? = Float(strWeight)
            let newBmi = record.bmi / Float(thisWeight!)
            alert.addAction(UIAlertAction(title: "Save",
                                          style: .default,
                                          handler:
                                          { [weak self] _ in guard
                                             let field = alert.textFields?.first,
                                             let newName = field.text,
                                             !newName.isEmpty
                else{
                    return
                    }
                let weight : Float? = Float(newName)
                self?.updateRecord(record: record, newWeight: Float(weight!), newBmi: newBmi*Float(weight!))
            }))
            self.present (alert,animated : true)
        }
        editAction.backgroundColor = .magenta
        
        
        let swipeConfiguration = UISwipeActionsConfiguration(actions: [editAction])
        return swipeConfiguration
    }
    
    // Gesture Control for deleting a BMI record
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let record = bmiRecords[indexPath.row]
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { _,_,_ in
            self.deleteRecord(record: record)
        }
       
        let swipeConfiguration = UISwipeActionsConfiguration(actions: [deleteAction])
        return swipeConfiguration
    }

    // Method to get all the non Deleted BMI records in tableview
    
    func nonDeletedRecords(){
        do{
            //bmiRecords =  try context.fetch(BMIRecords.fetchRequest())
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
           
        }
    }
    
    // Method for reloading the table view
    
    override func viewDidAppear(_ animated: Bool)
        {
            tableView.reloadData()
        }
    
    // Method to delete a BMI record
    
    func deleteRecord(record: BMIRecords){
        context.delete(record)
        do{
            try context.save()
            nonDeletedRecords()
        } catch{
            
        }
    }
    
    // Method to update a BMI record
    
    func updateRecord(record :BMIRecords, newWeight : Float, newBmi : Float){
      
        record.weight = Float(newWeight)
        let bmi = String(format: "%.2f", Float(newBmi))
        let bmiF : Float? = Float(bmi)
        record.bmi = Float(bmiF!)
        do{
            try context.save()
            nonDeletedRecords()
        } catch{
            
        }
    }

}
