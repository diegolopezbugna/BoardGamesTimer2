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
            player.isPlaying = false
        }
        .onTapGesture {
            if player.isPlaying {
                player.isPlaying = false
            } else {
                game.changePlayingPlayer(player)
            }
        }
        .onChange(of: player.isPlaying) { oldValue, newValue in
//            print("Player \(player.playerColor.name) isPlaying: \(newValue)")
            onPlayerIsPlayingChanged(isPlaying: newValue)
        }
    }
    
    private func onPlayerIsPlayingChanged(isPlaying: Bool) {
        if isPlaying {
            updatePlayerTime()
            animateBackground()
            setTimer()
        } else {
            cancelTimer()
        }
    }
    
    private func setTimer() {
        timerHandler?.cancel()
        timer = Timer.publish(every: 1, on: .main, in: .common)
        timerHandler = timer.connect()
    }
    
    private func cancelTimer() {
      timerHandler?.cancel()
    }
    
    private func updatePlayerTime() {
        player.time += game.gameType == .incremental ? 1.0 : -1.0
    }
    
    private func animateBackground() {
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
