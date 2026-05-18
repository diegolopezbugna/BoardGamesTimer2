//
//  GameInProgressView.swift
//  BoardGamesTimer2
//
//  Created by Diego López Bugna on 26/04/2026.
//

import SwiftUI

struct GameInProgressView: View {
    let store: GameStore
    let onEnd: () -> Void
    @Environment(\.verticalSizeClass) var sizeClass

    var isLandscape: Bool {
        sizeClass == .compact
    }

    var body: some View {
        let layout = store.state.gridLayout(isLandscape: isLandscape)
        GeometryReader { geo in
            let fullHeight = geo.size.height + geo.safeAreaInsets.top + geo.safeAreaInsets.bottom
            let rowHeight = fullHeight / CGFloat(layout.rows)
            let column = GridItem(.flexible(), spacing: 0)
            LazyVGrid(columns: Array(repeating: column, count: layout.columns), spacing: 0) {
                ForEach(store.state.players) { playerState in
                    ProgressPlayerView(store: store, playerID: playerState.id)
                        .frame(height: rowHeight)
                }
            }
            .edgesIgnoringSafeArea(.all)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("End") {
                        store.send(.requestEndGame)
                    }
                }
            }
            .confirmationDialog(
                "Are you sure to end current game?",
                isPresented: Binding(
                    get: { store.state.endConfirmating },
                    set: { if !$0 { store.send(.cancelEndGame) } }
                )
            ) {
                Button("End game", role: .confirm) {
                    onEnd()
                }
                Button("Cancel", role: .cancel) { }
            } message: {
                Text("This action cannot be undone.")
            }
            .toolbar(.hidden, for: .tabBar)
        }
    }
}

#Preview {
    GameInProgressView(store: GameStore(), onEnd: {})
}
