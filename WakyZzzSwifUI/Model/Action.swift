//
//  Action.swift
//  WakyZzzSwifUI
//
//  Created by Alexandra Ivanova on 25/06/2024.
//

import Foundation

/// A struct representing an action.
struct Action: Identifiable, Codable {
    
    /// Unique identifier for the action.
    var id: UUID
    /// A description of the action.
    var description: String
    
    /// Initializes a new `Action` instance.
    /// - Parameters:
    ///   - id: The unique identifier for the action. Default is a new UUID.
    ///   - description: A description of the action.
    init(id: UUID = UUID(), description: String) {
        self.id = id
        self.description = description
    }
}
