//
//  SelectPlayerColorViewModel.swift
//  BoardGamesTimer2
//
//  Created by Diego López Bugna on 07/05/2026.
//

import Foundation
import SwiftUI

@Observable
class SelectPlayerColorViewModel {
    private let game: Game
    let player: Player

    var remainingPlayerColors: [PlayerColor] {
        game.availablePlayerColors.filter { pc in
            !game.players.map(\.playerColor).contains(pc) || pc == player.playerColor
        }
    }
    
    init(game: Game, player: Player) {
        self.game = game
        self.player = player
    }
    
    func previous() {
        let i = remainingPlayerColors.firstIndex(of: player.playerColor) ?? 0
        if i > 0 {
            player.playerColor = remainingPlayerColors[i - 1]
        }
    }

    var previousDisabled: Bool {
        player.playerColor == remainingPlayerColors.first
    }
    
    func next() {
        let i = remainingPlayerColors.firstIndex(of: player.playerColor) ?? 0
        if i < remainingPlayerColors.count - 1 {
            player.playerColor = remainingPlayerColors[i + 1]
        }
    }
    
    var nextDisabled: Bool {
        player.playerColor == remainingPlayerColors.last
    }
}
