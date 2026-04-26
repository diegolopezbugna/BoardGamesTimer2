//
//  ContentView.swift
//  BoardGamesTimer2
//
//  Created by Diego López Bugna on 20/04/2026.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        TabView {
            Tab("Play", image: "clock-timer-7") {
                let g = Game()
                NewGameView(game: g)
            }
            Tab("Players", image: "woman-man-7") {
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
