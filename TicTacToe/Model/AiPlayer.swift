//
//  AiPlayer.swift
//  TicTacToe
//
//  Created by Luca Becker on 15.03.23.
//

import Foundation

struct AiPlayer {
    
    // isMaxizing = true fuer computer
    static func minimax(board: Board, isMaximizingPlayer: Bool, depth: Int) -> Int {
        switch getGameState(for: board) {
        case .finished(winner: let winner):
            switch winner {
            case .none:
                return 0
            case .some(let wrapped):
                return  wrapped == .X ? -10: 10
            }
        case .inProgress(player: _):
            break
        }
        
        var board = board
        
        if isMaximizingPlayer {
            var maxEval = -1000
            (0..<3).forEach { row in
                (0..<3).forEach { col in
                    if board[row][col] == nil {
                        board[row][col] = .O
                        
                        maxEval = max(maxEval, minimax(board: board, isMaximizingPlayer: !isMaximizingPlayer, depth: depth + 1))
                        
                        board[row][col] = nil
                    }
                }
            }
            return maxEval
        } else {
            var minEval = 1000
            (0..<3).forEach { row in
                (0..<3).forEach { col in
                    if board[row][col] == nil {
                        board[row][col] = .X
                        
                        minEval = min(minEval, minimax(board: board, isMaximizingPlayer: !isMaximizingPlayer, depth: depth + 1))
                        
                        board[row][col] = nil
                    }
                }
            }
            return minEval
        }
    }
    
    static func getAIMove(board: Board, player: Player) -> (Int, Int)? {
        var maxEval = -1000
        var bestMove: (Int, Int)?
        
        var board = board
        (0..<3).forEach { row in
            (0..<3).forEach { col in
                if board[row][col] == nil {
                    board[row][col] = player
                    
                    let eval = minimax(board: board, isMaximizingPlayer: true, depth: 0)
                    
                    if eval > maxEval {
                        bestMove = (row, col)
                        maxEval = eval
                    }
                    
                    board[row][col] = nil
                }
            }
        }
        
        return bestMove
    }
    
    static func getGameState(for board: Board) -> GameState {
        // Check rows
        for row in 0..<3 {
            if let player = board[row][0], board[row][1] == player, board[row][2] == player {
                return .finished(winner: player)
            }
        }
        
        // Check columns
        for column in 0..<3 {
            if let player = board[0][column], board[1][column] == player, board[2][column] == player {
                return .finished(winner: player)
            }
        }
        
        // Check diagonals
        if let player = board[0][0], board[1][1] == player, board[2][2] == player {
            return .finished(winner: player)
        }
        
        if let player = board[0][2], board[1][1] == player, board[2][0] == player {
            return .finished(winner: player)
        }
        
        // Check for tie
        if board.allSatisfy({ !$0.contains(nil) }) {
            return .finished(winner: nil)
        }
        
        // Game still in progress
        return .inProgress(player: .X)
    }
}
