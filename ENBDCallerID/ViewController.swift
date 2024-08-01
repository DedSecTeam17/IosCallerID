//
//  ViewController.swift
//  ENBDCallerID
//
//  Created by Mohammed Elamin on 01/08/2024.
//

import UIKit
import CallKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        DispatchQueue.main.async {
            // Place the code that must be executed on the main thread here
            // For example, UI updates or CallKit related operations
            self.checkCallDirectoryStatus()
            
        }
        
        dump(JSONFileManager().loadNumbersFromJSON())
        
    }
    
    
    func checkCallDirectoryStatus() {
        let manager = CXCallDirectoryManager.sharedInstance
        manager.getEnabledStatusForExtension(withIdentifier: "com.deadsec.ENBDCallerID.EnbdCallerIdExtension") { (enabledStatus, error) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            } else if enabledStatus == .enabled {
                print("Call Directory is enabled.")
                self.updateCallerIdNumbers()
            } else {
                print("Call Directory is not enabled.")
                self.showCallerIDInstructions()
            }
        }
    }
    
    func updateCallerIdNumbers() {
        let newNumbers: [[String: String]] = [
            ["phoneNumber": "00971566711795", "label": "EMIRATES NBD PJSC \u{2705}"],
            ["phoneNumber": "00971525221632", "label": "EMIRATES NBD PJSC \u{2705}"]
        ]
        
        let sortedNumbers = newNumbers.sorted { first, second in
            if let firstNumber = first["phoneNumber"], let secondNumber = second["phoneNumber"],
               let firstNumberUInt = UInt64(firstNumber), let secondNumberUInt = UInt64(secondNumber) {
                return firstNumberUInt < secondNumberUInt
            }
            return false
        }
        
        JSONFileManager().createFileIfNeeded()
        
        JSONFileManager().saveNumbersToJSON(sortedNumbers)
        
        dump(JSONFileManager().loadNumbersFromJSON())
        
        CXCallDirectoryManager.sharedInstance.reloadExtension(withIdentifier: "com.deadsec.ENBDCallerID.EnbdCallerIdExtension") { error in
            if let error = error {
                print("Error reloading extension: \(error)")
            } else {
                print("Caller ID extension reloaded with new numbers.")
                //                    self.updateCallerIdNumbers()
            }
        }
    }
    
    func showCallerIDInstructions() {
        //           let alert = UIAlertController(title: "Enable Caller ID", message: "To enable Caller ID, please go to Settings > Phone > Call Blocking & Identification and turn on [Your App Name].", preferredStyle: .alert)
        //           alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        //           self.present(alert, animated: true, completion: nil)
    }
    
}

// ---> PLAN to reload extensions ===>
