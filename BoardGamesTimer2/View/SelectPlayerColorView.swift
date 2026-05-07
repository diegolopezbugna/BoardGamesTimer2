//
//  SelectColorView.swift
//  BoardGamesTimer2
//
//  Created by Diego López Bugna on 23/04/2026.
//

import SwiftUI

struct SelectPlayerColorView: View {
    @State private var viewModel: SelectPlayerColorViewModel
    
    init(game: Game, player: Player) {
        self.viewModel = SelectPlayerColorViewModel(game: game, player: player)
    }
    
    var body: some View {
        HStack {
            Button("<") {
                withAnimation(.linear(duration: 0.1)) {
                    viewModel.previous()
                }
            }
            .fontWeight(.bold)
            .disabled(viewModel.previousDisabled)
            RoundedRectangle(cornerRadius: 5)
                .fill(viewModel.player.playerColor.bgColor)
                .stroke(.black, lineWidth: 2)
                .frame(height: 35)

            Button(">") {
                withAnimation(.linear(duration: 0.1)) {
                    viewModel.next()
                }
            }
            .fontWeight(.bold)
            .disabled(viewModel.nextDisabled)
        }
    }
}

#Preview {
    let g = Game()
    SelectPlayerColorView(game: g, player: g.players[0])
}
