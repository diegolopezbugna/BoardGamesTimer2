//
//  GameInProgressView.swift
//  BoardGamesTimer2
//
//  Created by Diego López Bugna on 26/04/2026.
//

import SwiftUI

struct GameInProgressView: View {
    @Binding var game: Game
    @State var endConfirmating = false
    @State var shouldNavigateToEndGame = false
    
    let columns = [
        GridItem(.flexible(), spacing: 0),
        GridItem(.flexible(), spacing: 0)
    ]
    var rows: Int {
        $game.playerColors.count / 2 + $game.playerColors.count % 2
    }
    
    enum NavigationDestinations {
        case gameResults
    }
    
    var body: some View {
        NavigationStack {
            GeometryReader { geo in
                let fullHeight = geo.size.height + geo.safeAreaInsets.top + geo.safeAreaInsets.bottom
                let rowHeight = fullHeight / CGFloat(rows)
                LazyVGrid(columns: columns, spacing: 0) {
                    ForEach($game.playerColors) { $playerColor in
                        ProgressPlayerView(playerColor: playerColor,
                                           time: TimeInterval(game.gameType == GameType.initialPlusTurnTimerPerPlayer ? game.initialTime : 0),
                                           gameType: game.gameType,
                                           isPlaying: false)
                        .frame(height: rowHeight)
                    }
                }
                .edgesIgnoringSafeArea(.all)
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("End") {
                            endConfirmating = true
                        }
                    }
                }
                .confirmationDialog(
                    "Are you sure to end current game?",
                    isPresented: $endConfirmating
                ) {
                    Button("End game", role: .confirm) {
                        shouldNavigateToEndGame = true
                    }
                    Button("Cancel", role: .cancel) { }
                } message: {
                    Text("This action cannot be undone.")
                }
                .toolbar(.hidden, for: .tabBar)
            }
        }
        .navigationDestination(isPresented: $shouldNavigateToEndGame) {
            GameResultView()
        }
    }
}

#Preview {
    var g = Game()
    GameInProgressView(game: .constant(g))
}
