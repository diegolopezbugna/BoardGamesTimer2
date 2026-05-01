//
//  SelectColorView.swift
//  BoardGamesTimer2
//
//  Created by Diego López Bugna on 23/04/2026.
//

import SwiftUI

struct SelectPlayerColorView: View {
    private let game: Game
    @Binding var selected: PlayerColor
    
    var remainingPlayerColors: [PlayerColor] {
        game.availablePlayerColors.filter { pc in
            !game.players.map(\.playerColor).contains(pc) || pc == selected
        }
    }
    
    init(game: Game, selected: Binding<PlayerColor>) {
        self.game = game
        self._selected = selected
    }
    
    var body: some View {
        HStack {
            Button("<") {
                let i = remainingPlayerColors.firstIndex(of: selected) ?? 0
                if i > 0 {
                    withAnimation(.linear(duration: 0.1)) {
                        selected = remainingPlayerColors[i - 1]
                    }
                }
            }
            .fontWeight(.bold)
            .disabled(selected == game.availablePlayerColors.first)
            RoundedRectangle(cornerRadius: 5)
                .fill(selected.bgColor)
                .stroke(.black, lineWidth: 2)
                .frame(height: 35)

            Button(">") {
                let i = remainingPlayerColors.firstIndex(of: selected) ?? 0
                if i < remainingPlayerColors.count - 1 {
                    withAnimation(.linear(duration: 0.1)) {
                        selected = remainingPlayerColors[i + 1]
                    }
                }
            }
            .fontWeight(.bold)
            .disabled(selected == game.availablePlayerColors.last)
        }
    }
}

#Preview {
    let g = Game()
    SelectPlayerColorView(game: g, selected: .constant(g.availablePlayerColors[0]))
}
