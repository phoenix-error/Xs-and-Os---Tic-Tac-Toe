//
//  GameState.swift
//  TicTacToe
//
//  Created by Luca Becker on 11.03.23.
//

import Foundation

enum GameState: Equatable {
    case inProgress(player: Player)
    case finished(winner: Player?)
    
    var message: String {
        if case .inProgress(let player) = self {
            return ("State inProgress: \(player.getName())")
        } else if case .finished(let winner) = self {
            return ("State finished: \(winner?.getName() ?? "nil")")
        }
        return "Failed"
    }
}
