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
    @Environment(\.verticalSizeClass) var sizeClass

    var isLandscape: Bool {
        sizeClass == .compact
    }
    
    var rows: Int {
        if $game.players.count < 4 {
            isLandscape ? 1 : $game.players.count
        } else {
            isLandscape ? 2 : $game.players.count / 2 + $game.players.count % 2
        }
    }
    var columns: Int {
        Int(ceil(Double($game.players.count) / Double(rows)))
    }

    enum NavigationDestinations {
        case gameResults
    }
    
    var body: some View {
        NavigationStack {
            GeometryReader { geo in
                let fullHeight = geo.size.height + geo.safeAreaInsets.top + geo.safeAreaInsets.bottom
                let rowHeight = fullHeight / CGFloat(rows)
                let column = GridItem(.flexible(), spacing: 0)
                LazyVGrid(columns: Array(repeating: column, count: columns), spacing: 0) {
                    ForEach($game.players) { $player in
                        ProgressPlayerView(playerColor: player.playerColor,
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
    var game = Game()
    GameInProgressView(game: .constant(game))
}
