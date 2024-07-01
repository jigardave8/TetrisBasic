//
//  GameViewModel.swift
//  TetrisBasic
//
//  Created by Jigar on 01/07/24.
//

import SwiftUI
import Combine

class GameViewModel: ObservableObject {
    static let boardWidth = 10
    static let boardHeight = 20
    
    @Published var board: [[Cell]]
    @Published var currentPiece: Tetromino?
    @Published var score: Int = 0
    @Published var level: Int = 1
    @Published var isGameOver = false
    @Published var isGamePaused = false
    
    private var timer: AnyCancellable?
    private var frameRate: Double = 1.0
    
    init() {
        board = Array(repeating: Array(repeating: Cell(), count: GameViewModel.boardWidth), count: GameViewModel.boardHeight)
        startGame()
    }
    
    func startGame() {
        resetGame()
        spawnNewPiece()
        startTimer()
    }
    
    private func resetGame() {
        board = Array(repeating: Array(repeating: Cell(), count: GameViewModel.boardWidth), count: GameViewModel.boardHeight)
        score = 0
        level = 1
        isGameOver = false
        isGamePaused = false
        frameRate = 1.0
    }
    
    func restartGame() {
        startGame()
    }
    
    func pauseResume() {
        isGamePaused.toggle()
        if isGamePaused {
            timer?.cancel()
        } else {
            startTimer()
        }
    }
    
    private func startTimer() {
        timer?.cancel()
        timer = Timer.publish(every: frameRate, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.gameLoop()
            }
    }
    
    private func gameLoop() {
        guard !isGamePaused else { return }
        moveDown()
    }
    
    func spawnNewPiece() {
        currentPiece = Tetromino.random()
        if !isValidPosition() {
            isGameOver = true
            timer?.cancel()
        } else {
            placePiece()
        }
    }
    
    private func placePiece() {
        guard let piece = currentPiece else { return }
        for (row, col) in piece.cells {
            let boardRow = piece.origin.y + row
            let boardCol = piece.origin.x + col
            if boardRow >= 0 && boardRow < GameViewModel.boardHeight && boardCol >= 0 && boardCol < GameViewModel.boardWidth {
                board[boardRow][boardCol] = Cell(color: piece.color)
            }
        }
        objectWillChange.send()
    }
    
    private func clearPiece() {
        guard let piece = currentPiece else { return }
        for (row, col) in piece.cells {
            let boardRow = piece.origin.y + row
            let boardCol = piece.origin.x + col
            if boardRow >= 0 && boardRow < GameViewModel.boardHeight && boardCol >= 0 && boardCol < GameViewModel.boardWidth {
                board[boardRow][boardCol] = Cell()
            }
        }
    }
    
    func moveLeft() {
        clearPiece()
        currentPiece?.moveLeft()
        if !isValidPosition() {
            currentPiece?.moveRight()
        }
        placePiece()
    }
    
    func moveRight() {
        clearPiece()
        currentPiece?.moveRight()
        if !isValidPosition() {
            currentPiece?.moveLeft()
        }
        placePiece()
    }
    
    func moveDown() {
        clearPiece()
        currentPiece?.moveDown()
        if !isValidPosition() {
            currentPiece?.moveUp()
            placePiece()
            clearLines()
            spawnNewPiece()
        } else {
            placePiece()
        }
    }
    
    func rotate() {
        clearPiece()
        currentPiece?.rotate()
        if !isValidPosition() {
            currentPiece?.rotateBack()
        }
        placePiece()
    }
    
    func hardDrop() {
        while isValidPosition() {
            clearPiece()
            currentPiece?.moveDown()
        }
        currentPiece?.moveUp()
        placePiece()
        clearLines()
        spawnNewPiece()
    }
    
    private func isValidPosition() -> Bool {
        guard let piece = currentPiece else { return false }
        for (row, col) in piece.cells {
            let boardRow = piece.origin.y + row
            let boardCol = piece.origin.x + col
            if boardRow < 0 || boardRow >= GameViewModel.boardHeight || boardCol < 0 || boardCol >= GameViewModel.boardWidth {
                return false
            }
            if boardRow >= 0 && board[boardRow][boardCol].color != .clear {
                return false
            }
        }
        return true
    }
    
    private func clearLines() {
        var linesToRemove: [Int] = []
        for row in 0..<GameViewModel.boardHeight {
            if board[row].allSatisfy({ $0.color != .clear }) {
                linesToRemove.append(row)
            }
        }
        for line in linesToRemove.sorted(by: >) {
            board.remove(at: line)
            board.insert(Array(repeating: Cell(), count: GameViewModel.boardWidth), at: 0)
        }
        updateScore(clearedLines: linesToRemove.count)
    }
    
    private func updateScore(clearedLines: Int) {
        let basePoints = [0, 40, 100, 300, 1200]
        score += basePoints[min(clearedLines, 4)] * level
        level = min(10, 1 + score / 1000)
        frameRate = max(0.1, 1.0 - Double(level - 1) * 0.1)
        startTimer()
    }
}
