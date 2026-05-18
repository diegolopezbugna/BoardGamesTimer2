//
//  ProgressPlayerView.swift
//  BoardGamesTimer2
//
//  Created by Diego López Bugna on 26/04/2026.
//

import SwiftUI

struct ProgressPlayerView: View {
    let store: GameStore
    let playerID: UUID
    @State private var bgColor: Color

    private var player: PlayerState? {
        store.state.players.first { $0.id == playerID }
    }

    init(store: GameStore, playerID: UUID) {
        self.store = store
        self.playerID = playerID
        let initialColor = store.state.players
            .first { $0.id == playerID }?
            .playerColor.bgColor ?? .gray
        self._bgColor = State(initialValue: initialColor)
    }

    var body: some View {
        ZStack {
            Rectangle()
                .fill(bgColor)
            Text(player?.time.toString(showMs: false) ?? "")
                .foregroundStyle(player?.playerColor.textColor ?? .white)
                .font(.custom("Verdana", size: 44))
        }
        .onTapGesture {
            store.send(.playerTapped(playerID: playerID))
        }
        .onChange(of: player?.time) { _, _ in
            guard player?.isPlaying == true else { return }
            let baseColor = player?.playerColor.bgColor ?? .gray
            let pulseColor = player?.playerColor.bgColor2 ?? .gray
            withAnimation(.linear(duration: 0.5)) {
                bgColor = pulseColor
            } completion: {
                withAnimation(.linear(duration: 0.5)) {
                    bgColor = baseColor
                }
            }
        }
    }
}

#Preview {
    let store = GameStore()
    ProgressPlayerView(store: store, playerID: store.state.players[0].id)
}
