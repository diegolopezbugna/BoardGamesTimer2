//
//  Player.swift
//  BoardGamesTimer2
//
//  Created by Diego López Bugna on 01/05/2026.
//

import Foundation

@Observable
class Player: Identifiable {
    var id = UUID()
    var playerColor: PlayerColor
    var time: TimeInterval = 0.0
    var isPlaying: Bool = false
    var isFirstPlayer: Bool = false
    
    init(playerColor: PlayerColor) {
        self.playerColor = playerColor
    }
}
