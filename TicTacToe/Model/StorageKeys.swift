//
//  StorageKeys.swift
//  TicTacToe
//
//  Created by Luca Becker on 15.03.23.
//

import Foundation

enum StorageKeys: String {
    case difficulty
    
    // Statistics
    case wins
    case losses
    case draws
    
    // Streaks
    case highestStreak
    case streak
    
    var key: String {
        return "de.phoenix.XsAndOs.\(self.rawValue)"
    }
}
