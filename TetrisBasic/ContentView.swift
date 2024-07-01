//
//  ContentView.swift
//  TetrisBasic
//
//  Created by Jigar on 01/07/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var gameViewModel = GameViewModel()
    
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            
            VStack {
                ScoreView(score: gameViewModel.score, level: gameViewModel.level)
                
                GameBoardView(gameViewModel: gameViewModel)
                    .gesture(
                        DragGesture()
                            .onEnded { gesture in
                                let threshold: CGFloat = 50
                                if abs(gesture.translation.width) > abs(gesture.translation.height) {
                                    if gesture.translation.width > threshold {
                                        gameViewModel.moveRight()
                                    } else if gesture.translation.width < -threshold {
                                        gameViewModel.moveLeft()
                                    }
                                } else if gesture.translation.height > threshold {
                                    gameViewModel.hardDrop()
                                }
                            }
                    )
                    .gesture(
                        TapGesture()
                            .onEnded {
                                gameViewModel.rotate()
                            }
                    )
                
                HStack {
                    Button(action: gameViewModel.pauseResume) {
                        Image(systemName: gameViewModel.isGamePaused ? "play.fill" : "pause.fill")
                            .font(.largeTitle)
                            .foregroundColor(.white)
                    }
                    Spacer()
                    Button(action: gameViewModel.restartGame) {
                        Image(systemName: "arrow.clockwise")
                            .font(.largeTitle)
                            .foregroundColor(.white)
                    }
                }
                .padding()
            }
            
            if gameViewModel.isGameOver {
                GameOverView(score: gameViewModel.score, onRestart: gameViewModel.restartGame)
            }
            
            if gameViewModel.isGamePaused {
                PauseView(onResume: gameViewModel.pauseResume)
            }
        }
    }
}

struct ScoreView: View {
    let score: Int
    let level: Int
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Score: \(score)")
                Text("Level: \(level)")
            }
            .font(.headline)
            .foregroundColor(.white)
            Spacer()
        }
        .padding()
    }
}

struct GameOverView: View {
    let score: Int
    let onRestart: () -> Void
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.8)
            VStack {
                Text("Game Over")
                    .font(.largeTitle)
                    .foregroundColor(.red)
                Text("Score: \(score)")
                    .font(.title)
                    .foregroundColor(.white)
                Button("Restart", action: onRestart)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
        .edgesIgnoringSafeArea(.all)
    }
}

struct PauseView: View {
    let onResume: () -> Void
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.8)
            VStack {
                Text("Game Paused")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                Button("Resume", action: onResume)
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
        .edgesIgnoringSafeArea(.all)
    }
}
