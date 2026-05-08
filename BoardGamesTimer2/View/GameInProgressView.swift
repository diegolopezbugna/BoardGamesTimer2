//
//  GameInProgressView.swift
//  BoardGamesTimer2
//
//  Created by Diego López Bugna on 26/04/2026.
//

import SwiftUI

struct GameInProgressView: View {
    @State private var viewModel: GameInProgressViewModel
    @Environment(\.verticalSizeClass) var sizeClass

    var isLandscape: Bool {
        sizeClass == .compact
    }
    
    enum NavigationDestinations {
        case gameResults
    }
    
    init(game: Game) {
        self.viewModel = GameInProgressViewModel(game: game)
    }
    
    var body: some View {
        NavigationStack {
            GeometryReader { geo in
                let fullHeight = geo.size.height + geo.safeAreaInsets.top + geo.safeAreaInsets.bottom
                let rowHeight = fullHeight / CGFloat(viewModel.rows)
                let column = GridItem(.flexible(), spacing: 0)
                LazyVGrid(columns: Array(repeating: column, count: viewModel.columns), spacing: 0) {
                    ForEach($viewModel.game.players) { player in
                        ProgressPlayerView(game: $viewModel.game, player: player)
                        .frame(height: rowHeight)
                    }
                }
                .edgesIgnoringSafeArea(.all)
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("End") {
                            viewModel.endConfirmating = true
                        }
                    }
                }
                .confirmationDialog(
                    "Are you sure to end current game?",
                    isPresented: $viewModel.endConfirmating
                ) {
                    Button("End game", role: .confirm) {
                        viewModel.shouldNavigateToEndGame = true
                    }
                    Button("Cancel", role: .cancel) { }
                } message: {
                    Text("This action cannot be undone.")
                }
                .toolbar(.hidden, for: .tabBar)
            }
        }
        .navigationDestination(isPresented: $viewModel.shouldNavigateToEndGame) {
            GameResultView()
        }
    }
}

#Preview {
    var game = Game()
    GameInProgressView(game: game)
}
