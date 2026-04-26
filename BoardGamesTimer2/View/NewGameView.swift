//
//  NewGameView.swift
//  BoardGamesTimer2
//
//  Created by Diego López Bugna on 20/04/2026.
//

import SwiftUI

struct NewGameView: View {
    @Bindable var game: Game
    
    var body: some View {
        VStack {
            HStack {
                Text("Game type")
                    .fontWeight(.semibold)
                Picker("Game Type", selection: $game.gameType) {
                    ForEach(GameType.allCases) { option in
                        Text(option.rawValue)
                    }
                }
            }
            .padding(10)
            if game.gameType == .initialPlusTurnTimerPerPlayer {
                InitialPlusNewGameView(initialTime: $game.initialTime, perPlayerTime: $game.perPlayerTime)
            } else {
                IncrementalNewGameView()
            }
            VStack {
                Text("\(game.playersCount) Players")
                    .fontWeight(.semibold)
                Stepper("", value: $game.playersCount, in: 2...game.maxPlayers)
                    .labelsHidden()
            }
            .padding(EdgeInsets(top: 30, leading: 0, bottom: 10, trailing: 0))
            VStack {
                ForEach(1...game.playerColors.count, id: \.self) { index in
                    let pc = $game.playerColors[index - 1].bgColor
                    SelectColorView(colors: game.colors, selectedColor: pc)
                }
            }
            .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
            Spacer()
        }
        .onChange(of: game.playersCount) { oldValue, newValue in
            if newValue > oldValue {
                withAnimation {
                    game.addPlayerColor()
                }
            } else {
                withAnimation {
                    game.removePlayerColor()
                }
            }
        }
        .padding(20)
    }
}

#Preview {
    let g = Game()
    NewGameView(game: g)
}
