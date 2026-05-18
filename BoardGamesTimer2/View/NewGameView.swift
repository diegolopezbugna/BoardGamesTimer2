//
//  NewGameView.swift
//  BoardGamesTimer2
//
//  Created by Diego López Bugna on 20/04/2026.
//

import SwiftUI

struct NewGameView: View {
    let store: GameStore
    @Environment(\.verticalSizeClass) var sizeClass
    let onStart: () -> Void

    private var gameTypeBinding: Binding<GameType> {
        Binding(
            get: { store.state.gameType },
            set: { store.send(.setGameType($0)) }
        )
    }

    private var initialTimeBinding: Binding<Int> {
        Binding(
            get: { store.state.initialTime },
            set: { store.send(.setInitialTime($0)) }
        )
    }

    private var perPlayerTimeBinding: Binding<Int> {
        Binding(
            get: { store.state.perPlayerTime },
            set: { store.send(.setPerPlayerTime($0)) }
        )
    }

    var body: some View {
        VStack {
            if sizeClass == .regular {
                HStack {
                    Text("Game type")
                        .fontWeight(.semibold)
                    Picker("Game Type", selection: gameTypeBinding) {
                        ForEach(GameType.allCases) { option in
                            Text(option.rawValue)
                        }
                    }
                }
                .padding(10)
                if store.state.gameType == .initialPlusTurnTimerPerPlayer {
                    InitialPlusNewGameView(initialTime: initialTimeBinding, perPlayerTime: perPlayerTimeBinding)
                } else {
                    IncrementalNewGameView()
                }
                VStack {
                    Text("\(store.state.players.count) Players")
                        .fontWeight(.semibold)
                        .contentTransition(.numericText())
                    Stepper("") {
                        withAnimation {
                            store.send(.addPlayer)
                        }
                    } onDecrement: {
                        withAnimation {
                            store.send(.removePlayer)
                        }
                    }
                    .labelsHidden()
                }
                .padding(EdgeInsets(top: sizeClass == .compact ? 0 : 30, leading: 0, bottom: 10, trailing: 0))
            } else {
                HStack {
                    Text("Game type")
                        .fontWeight(.semibold)
                    Picker("Game Type", selection: gameTypeBinding) {
                        ForEach(GameType.allCases) { option in
                            Text(option.rawValue)
                        }
                    }
                    if store.state.gameType == .initialPlusTurnTimerPerPlayer {
                        InitialPlusNewGameView(initialTime: initialTimeBinding, perPlayerTime: perPlayerTimeBinding)
                    } else {
                        IncrementalNewGameView()
                    }
                    Spacer()
                    VStack {
                        Text("\(store.state.players.count) Players")
                            .fontWeight(.semibold)
                            .contentTransition(.numericText())
                        Stepper("") {
                            withAnimation {
                                store.send(.addPlayer)
                            }
                        } onDecrement: {
                            withAnimation {
                                store.send(.removePlayer)
                            }
                        }
                        .labelsHidden()
                    }
                }
            }

            ScrollView {
                VStack {
                    ForEach(store.state.players) { playerState in
                        SelectPlayerColorView(store: store, playerID: playerState.id)
                    }
                }
                .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
            }
            Spacer()
        }
        .navigationTitle("New Game")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Start") {
                    onStart()
                }
            }
        }
        .padding(sizeClass == .compact ? 0 : 20)
    }
}

#Preview {
    NewGameView(store: GameStore(), onStart: {})
}
