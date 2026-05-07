//
//  NewGameView.swift
//  BoardGamesTimer2
//
//  Created by Diego López Bugna on 20/04/2026.
//

import SwiftUI

struct NewGameView: View {
    @State private var viewModel: NewGameViewModel
    @Environment(\.verticalSizeClass) var sizeClass
    
    init(game: Game) {
        self.viewModel = NewGameViewModel(game: game)
    }
    
    var body: some View {
        NavigationStack{
            VStack {
                if sizeClass == .regular {
                    HStack {
                        Text("Game type")
                            .fontWeight(.semibold)
                        Picker("Game Type", selection: $viewModel.game.gameType) {
                            ForEach(GameType.allCases) { option in
                                Text(option.rawValue)
                            }
                        }
                    }
                    .padding(10)
                    if viewModel.game.gameType == .initialPlusTurnTimerPerPlayer {
                        InitialPlusNewGameView(initialTime: $viewModel.game.initialTime, perPlayerTime: $viewModel.game.perPlayerTime)
                    } else {
                        IncrementalNewGameView()
                    }
                    VStack {
                        Text("\(viewModel.playersCount) Players")
                            .fontWeight(.semibold)
                        Stepper("") {
                            withAnimation {
                                viewModel.addPlayer()
                            }
                        } onDecrement: {
                            withAnimation {
                                viewModel.removePlayer()
                            }
                        }
                        .labelsHidden()
                    }
                    .padding(EdgeInsets(top: sizeClass == .compact ? 0 : 30, leading: 0, bottom: 10, trailing: 0))
                } else {
                    HStack {
                        Text("Game type")
                            .fontWeight(.semibold)
                        Picker("Game Type", selection: $viewModel.game.gameType) {
                            ForEach(GameType.allCases) { option in
                                Text(option.rawValue)
                            }
                        }
                        if viewModel.game.gameType == .initialPlusTurnTimerPerPlayer {
                            InitialPlusNewGameView(initialTime: $viewModel.game.initialTime, perPlayerTime: $viewModel.game.perPlayerTime)
                        } else {
                            IncrementalNewGameView()
                        }
                        Spacer()
                        VStack {
                            Text("\(viewModel.playersCount) Players")
                                .fontWeight(.semibold)
                            Stepper("") {
                                withAnimation {
                                    viewModel.addPlayer()
                                }
                            } onDecrement: {
                                withAnimation {
                                    viewModel.removePlayer()
                                }
                            }
                            .labelsHidden()
                        }
                    }
                }
                
                ScrollView {
                    VStack {
                        ForEach($viewModel.game.players) { $player in
                            SelectPlayerColorView(game: viewModel.game, selected: $player.playerColor)
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
                        GameInProgressView(game: viewModel.game)
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
