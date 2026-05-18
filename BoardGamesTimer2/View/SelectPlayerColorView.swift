//
//  SelectColorView.swift
//  BoardGamesTimer2
//
//  Created by Diego López Bugna on 23/04/2026.
//

import SwiftUI

struct SelectPlayerColorView: View {
    let store: GameStore
    let playerID: UUID

    private var playerState: PlayerState? {
        store.state.players.first { $0.id == playerID }
    }

    private var remainingColors: [PlayerColor] {
        store.state.remainingColors(for: playerID)
    }

    private var previousDisabled: Bool {
        playerState?.playerColor == remainingColors.first
    }

    private var nextDisabled: Bool {
        playerState?.playerColor == remainingColors.last
    }

    var body: some View {
        HStack {
            Button("<") {
                withAnimation(.linear(duration: 0.1)) {
                    store.send(.selectPreviousColor(playerID: playerID))
                }
            }
            .fontWeight(.bold)
            .disabled(previousDisabled)
            RoundedRectangle(cornerRadius: 5)
                .fill(playerState?.playerColor.bgColor ?? .gray)
                .stroke(.black, lineWidth: 2)
                .frame(height: 35)
            Button(">") {
                withAnimation(.linear(duration: 0.1)) {
                    store.send(.selectNextColor(playerID: playerID))
                }
            }
            .fontWeight(.bold)
            .disabled(nextDisabled)
        }
    }
}

#Preview {
    let store = GameStore()
    SelectPlayerColorView(store: store, playerID: store.state.players[0].id)
}
