//
//  Action.swift
//  WakyZzzSwifUI
//
//  Created by Alexandra Ivanova on 25/06/2024.
//

import Foundation

struct Action: Identifiable, Codable {
    var id: UUID
    var description: String
    
    init(id: UUID = UUID(), description: String) {
        self.id = id
        self.description = description
    }
}
