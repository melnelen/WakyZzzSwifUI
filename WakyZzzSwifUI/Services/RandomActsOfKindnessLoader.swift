//
//  RandomActsOfKindnessLoader.swift
//  WakyZzzSwifUI
//
//  Created by Alexandra Ivanova on 10/07/2024.
//

import Foundation

/// A utility class for loading random acts of kindness from a JSON file.
class RandomActsOfKindnessLoader {
    
    /// Loads random acts of kindness from a JSON file located in the app bundle.
    /// - Returns: An array of strings, each representing a random act of kindness.
    /// - Note: This method will cause a fatal error if the JSON file cannot be found or if there is an error during loading or parsing the file.
    static func loadRandomActsOfKindness() -> [String] {
        // Attempt to find the URL of the JSON file in the app bundle
        guard let url = Bundle.main.url(forResource: "random_acts_of_kindness", withExtension: "json") else {
            fatalError("Unable to find random_acts_of_kindness.json")
        }
        
        do {
            // Attempt to load the data from the file at the specified URL
            let data = try Data(contentsOf: url)
            // Attempt to decode the data into an array of strings
            let randomActs = try JSONDecoder().decode([String].self, from: data)
            return randomActs
        } catch {
            // If an error occurs during loading or parsing, cause a fatal error with a descriptive message
            fatalError("Failed to load and parse random_acts_of_kindness.json: \(error)")
        }
    }
}
