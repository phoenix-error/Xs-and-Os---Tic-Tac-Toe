//
//  Player.swift
//  TicTacToe
//
//  Created by Luca Becker on 11.03.23.
//

import Foundation

public enum Player: Int {
    case X, O
    
    mutating func toggle() {
        if self == .X {
            self = .O
        } else {
            self = .X
        }
    }
    
    func getName() -> String {
        switch self {
        case .X:
            return "X"
        case .O:
            return "O"
        }
    }
}
