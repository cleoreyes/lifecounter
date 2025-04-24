//
//  GameEvent.swift
//  lifecounteragain
//
//  Created by Cleo Reyes on 4/23/25.
//

import Foundation

struct GameEvent {
    let message: String
    let timestamp: Date
    
    init(message: String) {
        self.message = message
        self.timestamp = Date()
    }
}
