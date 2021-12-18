//
//  ViewController.swift
//  BMITrackingApp
//
//  Created by Shrinal Patel on 13/12/21.
//  Final Exam for MAPD714 - iOS Development
//  Description: This is a simple BMI Calculator app to calculate BMI In both Standard and Imperial units. It also supports persistant data storage.


import UIKit
import CoreData

class ViewController: UIViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
      
    private var bmiRecords = [BMIRecords]()
    var weight : Float? = 0
    var height : Float? = 0
    var bmi : Float? = 0
    
    @IBOutlet weak var nameLabel: UITextField!
    @IBOutlet weak var genderLabel: UITextField!
    @IBOutlet weak var ageLabel: UITextField!
    @IBOutlet weak var weightLabel: UITextField!
    @IBOutlet weak var heightLabel: UITextField!
    @IBOutlet weak var bmiResultLabel: UILabel!
    @IBOutlet weak var bmiMessageLabel: UILabel!
    @IBOutlet weak var unitSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bmiResultLabel.text = ""
        bmiMessageLabel.text = ""
    }
    
    // Action Function to operate switch control
    
    @IBAction func unitSwitchTap(_ sender: UISwitch) {
        if unitSwitch.isOn {
            weightLabel.placeholder = "in pounds"
            heightLabel.placeholder = "in inches"
            unitSwitch.setOn(true, animated:true)
            }
        else {
                weightLabel.placeholder = "in kilograms"
                heightLabel.placeholder = "in metres"
                unitSwitch.setOn(false, animated:true)
            }
    }
    
    // Method to calculate BMI in both imperial and metric units
    
    @IBAction func calculateButtonTap(_ sender: UIButton) {
        if (self.weightLabel.text!=="" || self.heightLabel.text!=="")
                {
                    let alertController = UIAlertController(title: "Field/s left empty!", message:
                                                                "Please enter both Height and Weight", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .cancel))

                    self.present(alertController, animated: true, completion: nil)
                    
                }
                else
                {
                    weight = Float(self.weightLabel.text!)!
                    height = Float(self.heightLabel.text!)!
                    
                    if unitSwitch.isOn
                    {
                        bmi = Float((weight!*703)/(height!*height!))
                        self.bmiResultLabel.text = String(format:"%.\(2)f", bmi!)
                        
                        if (bmi! < 16)
                        { self.bmiMessageLabel.text = "Category: Severe Thinness"}
                        else if (bmi! >= 16 && bmi! < 17)
                        { self.bmiMessageLabel.text = "Category: Moderate Thinness"}
                        else if (bmi! >= 17 && bmi! < 18.5)
                        { self.bmiMessageLabel.text = "Category: Mild Thinness"}
                        else if (bmi! >= 18.5 && bmi! < 25)
                        { self.bmiMessageLabel.text = "Category: Normal"}
                        else if (bmi! >= 25 && bmi! < 30)
                        { self.bmiMessageLabel.text = "Category: Overweight"}
                        else if (bmi! >= 30 && bmi! < 35)
                        { self.bmiMessageLabel.text = "Category: Obese Class I"}
                        else if (bmi! >= 35 && bmi! <= 40)
                        { self.bmiMessageLabel.text = "Category: Obese Class II"}
                        else if (bmi! > 40)
                        { self.bmiMessageLabel.text = "Category: Obese Class III"}
                    }
                        
                    else
                    {
                        bmi = Float(weight!/(height!*height!))
                        self.bmiResultLabel.text = String(format:"%.\(2)f", bmi!)
                        
                        if (bmi! < 16)
                        { self.bmiMessageLabel.text = "Category: Severe Thinness"}
                        else if (bmi! >= 16 && bmi! < 17)
                        { self.bmiMessageLabel.text = "Category: Moderate Thinness"}
                        else if (bmi! >= 17 && bmi! < 18.5)
                        { self.bmiMessageLabel.text = "Category: Mild Thinness"}
                        else if (bmi! >= 18.5 && bmi! < 25)
                        { self.bmiMessageLabel.text = "Category: Normal"}
                        else if (bmi! >= 25 && bmi! < 30)
                        { self.bmiMessageLabel.text = "Category: Overweight"}
                        else if (bmi! >= 30 && bmi! < 35)
                        { self.bmiMessageLabel.text = "Category: Obese Class I"}
                        else if (bmi! >= 35 && bmi! <= 40)
                        { self.bmiMessageLabel.text = "Category: Obese Class II"}
                        else if (bmi! > 40)
                        { self.bmiMessageLabel.text = "Category: Obese Class III"}
                    }
                    addRecord(weight: Float(weight!) , bmi: Float(bmi!))
                }
    }
    
    // Action Function to send the record to the BMITrackingViewController Screen
    
    @IBAction func trackButtonTap(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "BMITrackingViewController") as! BMITrackingViewController
        vc.weight = weightLabel.text
        vc.bmi = bmiResultLabel.text
        vc.name = nameLabel.text
        
        self.navigationController?.pushViewController(vc , animated: true)
    }
    
    // Method for adding a new BMI record
    
    func addRecord(weight :Float, bmi : Float){
            let newRecord = BMIRecords(context: context)
            
            newRecord.weight = weight
            newRecord.bmi = bmi
            
            do{
                try context.save()
                print("Save")
            }catch{
                
            }
        }
    
}

