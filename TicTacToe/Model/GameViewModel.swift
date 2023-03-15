//
//  GameViewModel.swift
//  TicTacToe
//
//  Created by Luca Becker on 11.03.23.
//

import SwiftUI

struct PopupAlert: Identifiable, Equatable {
    let id = UUID()
    var title: String
    var message: String
}

enum ComputerDifficulty: String, Identifiable, CaseIterable, Codable {
    var id: String {
        self.rawValue
    }
    
    case random
    case smart
    case ai
}

final class GameViewModel: ObservableObject {
    typealias Board = [[Player?]]
    private(set) var board: Board = Array(repeating: Array(repeating: nil, count: 3), count: 3) {
        didSet {
            updateGameState()
        }
    }
    
    @Published var currentPlayer: Player = .X
    @Published var popup: PopupAlert?
    @Published var gameState: GameState = .inProgress(player: .X)
    
    @AppStorage(StorageKeys.difficulty.rawValue) var difficulty: ComputerDifficulty = .smart
    
    func resetGame() {
        board = Array(repeating: Array(repeating: nil, count: 3), count: 3)
        currentPlayer = .X
        popup = nil
    }
    
    func updateGameState() {
        gameState = getGameState(for: self.board)
        
        if case .finished(let winner) = gameState {
            switch winner {
            case .none:
                popup = PopupAlert(title: "Draw", message: "Play again")
            case .some(let player):
                if player == .X {
                    popup = PopupAlert(title: "Victory", message: "Congratulations")
                } else {
                    popup = PopupAlert(title: "Loss", message: "Better luck next time")
                }
            }
        }
    }
    
    func makeMove(ind: Int) {
        let (row, col) = indexToRowAndCol(ind: ind)
        withAnimation {
            if board[row][col] == nil {
                board[row][col] = currentPlayer
                self.currentPlayer.toggle()
            }
        }
        
        if case .inProgress(_) = gameState {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double.random(in: 0.5...5.0)) {
                let (row, col) = self.getComputerMove()
                withAnimation {
                    self.board[row][col] = self.currentPlayer
                    self.objectWillChange.send()
                    self.currentPlayer.toggle()
                }
            }
        }
        
    }
    
    func getSizeOfCell(for width: CGFloat) -> CGFloat {
        // padding between cells
        let padding = 20
        return (width - CGFloat(5 * padding)) / 3
    }
    
    func indexToRowAndCol(ind: Int) -> (Int, Int) {
        let row = ind / 3
        let col = ind % 3
        
        return (row, col)
    }
    
    func getCellState(for ind: Int) -> Player? {
        let (row, col) = indexToRowAndCol(ind: ind)
        return board[row][col]
    }
}

// MARK: Minimax
extension GameViewModel {
    
    func getComputerMove() -> (Int, Int) {
        switch difficulty {
        case .random:
            return getRandomMove(baord: self.board, player: .O)
        case .smart:
            var tempMove = getWinningMove(board: self.board, player: .O)
            
            if tempMove == nil {
                tempMove = getWinningMove(board: self.board, player: .X)
            }
            
            if tempMove != nil {
                return tempMove!
            } else {
                return getRandomMove(baord: self.board, player: .O)
            }
        case .ai:
            return getRandomMove(baord: self.board, player: .O)
        }
    }
    
    func getRandomMove(baord: Board, player: Player) -> (Int, Int) {
        assert(availableMoves(for: self.board).count > 0)
        var move: (Int, Int)
        repeat {
            move = self.indexToRowAndCol(ind: (availableMoves(for: self.board).randomElement() ?? 0))
        } while self.board[move.0][move.1] != nil
        return move
    }
    
    func getWinningMove(board: Board, player: Player) -> (Int, Int)? {
        // Check rows for winning move
        for row in 0..<3 {
            let rowValues = board[row]
            if rowValues.filter({ $0 == player }).count == 2 && rowValues.contains(nil) {
                let col = rowValues.firstIndex(of: nil)!
                return (row, col)
            }
        }
        
        // Check columns for winning move
        for col in 0..<3 {
            let colValues = board.map({ $0[col] })
            if colValues.filter({ $0 == player }).count == 2 && colValues.contains(nil) {
                let row = colValues.firstIndex(of: nil)!
                return (row, col)
            }
        }
        
        // Check diagonals for winning move
        let diagonal1 = [board[0][0], board[1][1], board[2][2]]
        let diagonal2 = [board[0][2], board[1][1], board[2][0]]
        
        if diagonal1.filter({ $0 == player }).count == 2 && diagonal1.contains(nil) {
            let index = diagonal1.firstIndex(of: nil)!
            return (index, index)
        }
        else if diagonal2.filter({ $0 == player }).count == 2 && diagonal2.contains(nil) {
            let index = diagonal2.firstIndex(of: nil)!
            return (index, 2 - index)
        }
        
        return nil
    }
    
    func availableMoves(for board: Board) -> [Int] {
        var moves: [Int] = []
        
        for i in 0..<9 {
            let (row, col) = indexToRowAndCol(ind: i)
            if board[row][col] == nil {
                moves.append(i)
            }
        }
        
        return moves
    }
    
    func getGameState(for board: Board) -> GameState {
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
        return .inProgress(player: currentPlayer)
    }
}
