//
//  GameResultView.swift
//  BoardGamesTimer2
//
//  Created by Diego López Bugna on 28/04/2026.
//

import SwiftUI

struct GameResultView: View {
    let onNewGame: () -> Void

    var body: some View {
        VStack(spacing: 20) {
            Text("Game Over")
                .font(.largeTitle)
            Button("New Game") {
                onNewGame()
            }
        }
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    GameResultView(onNewGame: {})
}
