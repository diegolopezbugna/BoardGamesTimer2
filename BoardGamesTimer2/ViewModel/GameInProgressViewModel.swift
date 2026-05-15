//
//  GameInProgressViewModel.swift
//  BoardGamesTimer2
//
//  Created by Diego López Bugna on 07/05/2026.
//

import Foundation

@Observable
class GameInProgressViewModel {
    var game: Game
    var endConfirmating = false
    var isLandscape = false

    var rows: Int {
        if game.players.count < 4 {
            isLandscape ? 1 : game.players.count
        } else {
            isLandscape ? 2 : game.players.count / 2 + game.players.count % 2
        }
    }
    var columns: Int {
        Int(ceil(Double(game.players.count) / Double(rows)))
    }

    init(game: Game) {
        self.game = game
    }

}
