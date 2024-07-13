//
//  GameBoardView.swift
//  TetrisBasic
//
//  Created by Jigar on 01/07/24.
//

import SwiftUI

struct GameBoardView: View {
    @ObservedObject var gameViewModel: GameViewModel
    
    var body: some View {
        VStack(spacing: 1) {
            ForEach(0..<GameViewModel.boardHeight, id: \.self) { row in
                HStack(spacing: 1) {
                    ForEach(0..<GameViewModel.boardWidth, id: \.self) { col in
                        CellView(cell: gameViewModel.board[row][col])
                    }
                }
            }
        }
        .background(Color.gray.opacity(0.3))
        .border(Color.white, width: 2)
    }
}


struct CellView: View {
    let cell: Cell
    
    var body: some View {
        Rectangle()
            .fill(cell.color)
            .frame(width: UIScreen.main.bounds.width / CGFloat(GameViewModel.boardWidth) - 1,
                   height: UIScreen.main.bounds.width / CGFloat(GameViewModel.boardWidth) - 1)
    }
}
