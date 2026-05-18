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
                PlayCoordinator()
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
    HomeView()
}
