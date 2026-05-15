//
//  GameResultView.swift
//  BoardGamesTimer2
//
//  Created by Diego López Bugna on 28/04/2026.
//

import SwiftUI

struct GameResultView: View {
    @Environment(PlayRouter.self) private var router

    var body: some View {
        VStack(spacing: 20) {
            Text("Game Over")
                .font(.largeTitle)
            Button("New Game") {
                router.newGame()
            }
        }
    }
}

#Preview {
    GameResultView()
}
