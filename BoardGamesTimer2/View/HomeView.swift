//
//  ContentView.swift
//  BoardGamesTimer2
//
//  Created by Diego López Bugna on 20/04/2026.
//

import SwiftUI

struct HomeView: View {
    @State private var playRouter = PlayRouter()

    var body: some View {
        TabView {
            Tab("Play", image: "clock-timer-7") {
                NavigationStack(path: $playRouter.path) {
                    NewGameView(game: playRouter.game)
                        .navigationDestination(for: PlayRoute.self) { route in
                            switch route {
                            case .gameInProgress:
                                GameInProgressView(game: playRouter.game)
                            case .gameResult:
                                GameResultView()
                            }
                        }
                }
                .id(ObjectIdentifier(playRouter.game))
                .environment(playRouter)
            }
            Tab("Players", image: "woman-man-7") {
                PlayersView()
            }
            Tab("Plays", image: "list-simple-star-7") {
            }
            Tab("Settings", image: "spanner-7") {
            }
        }
    }
}

#Preview {
    let g = Game()
    HomeView()
}
