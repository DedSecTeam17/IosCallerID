//
//  JSONFileManager.swift
//  ENBDCallerID
//
//  Created by Mohammed Elamin on 01/08/2024.
//

import Foundation

class JSONFileManager {
    
    let appGroupID = "group.dedsec.shared"
    
    let fileName = "CallerIDData.json"
    
    func getSharedContainerURL() -> URL? {
        return FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: appGroupID)
    }
    
    func getJSONFileURL() -> URL? {
        guard let sharedContainerURL = getSharedContainerURL() else {
            return nil
        }
        return sharedContainerURL.appendingPathComponent(fileName)
    }
    
    func createFileIfNeeded() {
        guard let fileURL = getJSONFileURL() else {
            print("Failed to get file URL.")
            return
        }
        
        let fileManager = FileManager.default
        
        // Check if the file exists
        if !fileManager.fileExists(atPath: fileURL.path) {
            do {
                // Create the file with default content (an empty array in this case)
                let initialContent: [[String: String]] = []
                let jsonData = try JSONSerialization.data(withJSONObject: initialContent, options: .prettyPrinted)
                
                // Create the file with the initial content
                try jsonData.write(to: fileURL)
                print("File created successfully at: \(fileURL.path)")
            } catch {
                print("Error creating JSON file: \(error.localizedDescription)")
            }
        } else {
            print("File already exists at: \(fileURL.path)")
        }
    }
    
    func saveNumbersToJSON(_ numbers: [[String: String]]) {
        guard let fileURL = getJSONFileURL() else {
            print("Failed to get file URL.")
            return
        }
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: numbers, options: .prettyPrinted)
            try jsonData.write(to: fileURL)
            print("JSON data saved successfully at: \(fileURL.path)")
        } catch {
            print("Error saving JSON data: \(error.localizedDescription)")
        }
    }
    
    func loadNumbersFromJSON() -> [[String: String]]? {
        guard let fileURL = getJSONFileURL() else {
            print("Failed to get file URL.")
            return nil
        }
        
        do {
            let data = try Data(contentsOf: fileURL)
            let json = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: String]]
            return json
        } catch {
            print("Error loading JSON data: \(error.localizedDescription)")
            return nil
        }
    }
}
