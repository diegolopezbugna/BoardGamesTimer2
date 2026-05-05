//
//  ProgressPlayerView.swift
//  BoardGamesTimer2
//
//  Created by Diego López Bugna on 26/04/2026.
//

import SwiftUI
internal import Combine

struct ProgressPlayerView: View {
    @Binding var game: Game
    @Binding var player: Player
    @State var bgColor: Color

    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(bgColor)
            Text("\(player.time.toString(showMs: false))")
                .foregroundStyle(player.playerColor.textColor)
                .font(.custom("Verdana", size: 44))
                .onReceive(timer) { output in
                    if player.isPlaying {
                        player.time += game.gameType == .incremental ? 1.0 : -1.0
                        withAnimation(.linear(duration: 0.5), ) {
                            self.bgColor = player.playerColor.bgColor2
                        } completion: {
                            withAnimation(.linear(duration: 0.5)) {
                                self.bgColor = player.playerColor.bgColor
                            }
                        }
                    }
                }
        }
        .onTapGesture {
            if player.isPlaying {
                player.isPlaying = false
            } else {
                game.changePlayingPlayer(player)
            }
        }
    }
    
    init(game: Binding<Game>, player: Binding<Player>) {
        self._game = game
        self._player = player
        self.bgColor = player.playerColor.bgColor.wrappedValue
    }
}

#Preview {
    let g = Game()
    let p = g.players[0]
    ProgressPlayerView(game: .constant(g), player: .constant(p))
}
