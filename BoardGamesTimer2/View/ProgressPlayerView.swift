//
//  ProgressPlayerView.swift
//  BoardGamesTimer2
//
//  Created by Diego López Bugna on 26/04/2026.
//

import SwiftUI
internal import Combine

struct ProgressPlayerView: View {
    var playerColor: PlayerColor
    @State var time: TimeInterval
    @State var gameType: GameType
    @State var isPlaying: Bool
    
    @State var bgColor: Color
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(bgColor)
            Text("\(time.toString(showMs: false))")
                .foregroundStyle(playerColor.textColor)
                .font(.custom("Verdana", size: 44))
                .onReceive(timer) { output in
                    if isPlaying {
                        time += gameType == .incremental ? 1.0 : -1.0
                        withAnimation(.linear(duration: 0.5), ) {
                            self.bgColor = playerColor.bgColor2
                        } completion: {
                            withAnimation(.linear(duration: 0.5)) {
                                self.bgColor = playerColor.bgColor
                            }
                        }
                    }
                }
        }
        .onTapGesture {
            isPlaying = !isPlaying
        }
    }
    
    init(playerColor: PlayerColor, time: TimeInterval, gameType: GameType, isPlaying: Bool) {
        self.playerColor = playerColor
        self.time = time
        self.gameType = gameType
        self.isPlaying = isPlaying
        self.bgColor = playerColor.bgColor
    }
}

#Preview {
    let g = Game()
    let pc = g.availablePlayerColors[0]
    ProgressPlayerView(playerColor: pc, time: TimeInterval(g.initialTime),
                       gameType: g.gameType,
                       isPlaying: false)
}
