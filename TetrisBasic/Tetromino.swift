//
//  Tetromino.swift
//  TetrisBasic
//
//  Created by Jigar on 01/07/24.
//

import SwiftUI

struct Tetromino {
    var cells: [(row: Int, col: Int)]
    var color: Color
    var origin: (x: Int, y: Int)
    
    mutating func moveLeft() {
        origin.x -= 1
    }
    
    mutating func moveRight() {
        origin.x += 1
    }
    
    mutating func moveDown() {
        origin.y += 1
    }
    
    mutating func moveUp() {
        origin.y -= 1
    }
    
    mutating func rotate() {
        cells = cells.map { (-$0.col, $0.row) }
    }
    
    mutating func rotateBack() {
        cells = cells.map { ($0.col, -$0.row) }
    }
    
    static func random() -> Tetromino {
        let tetrominoes: [Tetromino] = [
            Tetromino(cells: [(0,0), (0,1), (0,2), (0,3)], color: .blue, origin: (3, 0)),  // I
            Tetromino(cells: [(0,0), (0,1), (1,0), (1,1)], color: .yellow, origin: (4, 0)),  // O
            Tetromino(cells: [(0,1), (1,0), (1,1), (1,2)], color: .purple, origin: (3, 0)),  // T
            Tetromino(cells: [(0,0), (1,0), (1,1), (1,2)], color: .green, origin: (3, 0)),  // L
            Tetromino(cells: [(0,2), (1,0), (1,1), (1,2)], color: .orange, origin: (3, 0)),  // J
            Tetromino(cells: [(0,0), (0,1), (1,1), (1,2)], color: .red, origin: (3, 0)),  // Z
            Tetromino(cells: [(0,1), (0,2), (1,0), (1,1)], color: .pink, origin: (3, 0))   // S
            
        ]
        
        
        return tetrominoes.randomElement()!
    }
}
