//
//  RandomActsOfKindnessLoader.swift
//  WakyZzzSwifUI
//
//  Created by Alexandra Ivanova on 10/07/2024.
//

import Foundation

class RandomActsOfKindnessLoader {
    static func loadRandomActsOfKindness() -> [String] {
        guard let url = Bundle.main.url(forResource: "random_acts_of_kindness", withExtension: "json") else {
            fatalError("Unable to find random_acts_of_kindness.json")
        }
        
        do {
            let data = try Data(contentsOf: url)
            let randomActs = try JSONDecoder().decode([String].self, from: data)
            return randomActs
        } catch {
            fatalError("Failed to load and parse random_acts_of_kindness.json: \(error)")
        }
    }
}
