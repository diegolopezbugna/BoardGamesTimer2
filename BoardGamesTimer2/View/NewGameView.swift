//
//  NewGameView.swift
//  BoardGamesTimer2
//
//  Created by Diego López Bugna on 20/04/2026.
//

import SwiftUI

struct NewGameView: View {
    @State var game: Game
    @State var playersCount: Int
    @Environment(\.verticalSizeClass) var sizeClass
    
    init(game: Game) {
        self.game = game
        self.playersCount = game.playerColors.count
    }
    
    var body: some View {
        NavigationStack{
            VStack {
                if sizeClass == .regular {
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
                        Text("\(playersCount) Players")
                            .fontWeight(.semibold)
                        Stepper("", value: $playersCount, in: 2...game.maxPlayers)
                            .labelsHidden()
                    }
                    .padding(EdgeInsets(top: sizeClass == .compact ? 0 : 30, leading: 0, bottom: 10, trailing: 0))
                } else {
                    HStack {
                        Text("Game type")
                            .fontWeight(.semibold)
                        Picker("Game Type", selection: $game.gameType) {
                            ForEach(GameType.allCases) { option in
                                Text(option.rawValue)
                            }
                        }
                        if game.gameType == .initialPlusTurnTimerPerPlayer {
                            InitialPlusNewGameView(initialTime: $game.initialTime, perPlayerTime: $game.perPlayerTime)
                        } else {
                            IncrementalNewGameView()
                        }
                        Spacer()
                        VStack {
                            Text("\(playersCount) Players")
                                .fontWeight(.semibold)
                            Stepper("", value: $playersCount, in: 2...game.maxPlayers)
                                .labelsHidden()
                        }
                    }
                }
                
                ScrollView {
                    VStack {
                        ForEach($game.playerColors) { $playerColor in
                            SelectPlayerColorView(game: game, selected: $playerColor)
                        }
                    }
                    .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
                }
                Spacer()
            }
            .navigationTitle("New Game")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink("Start") {
                        GameInProgressView(game: $game)
                    }
                }
            }
            .onChange(of: playersCount) { oldValue, newValue in
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
            .padding(sizeClass == .compact ? 0 : 20)
        }
    }
}

#Preview {
    let g = Game()
    NewGameView(game: g)
}
