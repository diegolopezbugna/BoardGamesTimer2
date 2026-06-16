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

    @State private var timer = Timer.publish(every: 1, on: .main, in: .common)
    @State private var timerHandler: Cancellable?
    
    var body: some View {
        ZStack {
            Color(bgColor)
            Text("\(player.time.toString(showMs: false))")
                .foregroundStyle(player.playerColor.textColor)
                .font(.custom("Verdana", size: 44))
                .onReceive(timer) { output in
                    if player.isPlaying {
                        updatePlayerTime()
                        animateBackground()
                    }
                }
        }
        .onDisappear {
            cancelTimer()
            player.isPlaying = false
        }
        .onTapGesture {
            if player.isPlaying {
                cancelTimer()
                player.isPlaying = false
            } else {
                updatePlayerTime()
                animateBackground()
                setTimer()
                game.changePlayingPlayer(player)
            }
        }
    }
    
    func setTimer() {
        timerHandler?.cancel()
        timer = Timer.publish(every: 1, on: .main, in: .common)
        timerHandler = timer.connect()
    }
    
    func cancelTimer() {
      timerHandler?.cancel()
    }
    
    func updatePlayerTime() {
        player.time += game.gameType == .incremental ? 1.0 : -1.0
    }
    
    func animateBackground() {
        withAnimation(.linear(duration: 0.5), ) {
            self.bgColor = player.playerColor.bgColor2
        } completion: {
            withAnimation(.linear(duration: 0.5)) {
                self.bgColor = player.playerColor.bgColor
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
    var g = Game()
    ProgressPlayerView(game: .constant(g), player: .constant(g.players[0]))
}
