//
//  NewGameViewModel.swift
//  BoardGamesTimer2
//
//  Created by Diego López Bugna on 07/05/2026.
//

import Foundation

@Observable
class NewGameViewModel {
    var game: Game
    var playersCount: Int {
        game.players.count
    }

    init(game: Game) {
        self.game = game
    }
    
    func addPlayer() {
        self.game.addPlayer()
    }
    
    func removePlayer() {
        self.game.removePlayer()
    }
}
