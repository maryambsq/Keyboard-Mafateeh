//
//  Item.swift
//  Keyboard-Mafateeh
//
//  Created by Maryam Amer Bin Siddique on 24/06/1446 AH.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
