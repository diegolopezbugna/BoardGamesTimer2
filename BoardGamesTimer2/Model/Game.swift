//
//  Game.swift
//  BoardGamesTimer2
//
//  Created by Diego López Bugna on 20/04/2026.
//
import Foundation
import SwiftUI
import Observation

struct PlayerColor : Identifiable, Equatable {
    let id: UUID = UUID()
    
    var name: String
    var textColor: Color
    var bgColor: Color
    var bgColor2: Color
}

@Observable
class Game : Equatable {
    static func == (lhs: Game, rhs: Game) -> Bool {
        lhs.players == rhs.players
    }
    
    var gameType: GameType = .incremental
    
    var initialTime = InitialPlusTurnTimerPerPlayerGameType.defaultInitialTime
    var perPlayerTime = InitialPlusTurnTimerPerPlayerGameType.defaultPerPlayerTime
    
    let availablePlayerColors = [
        PlayerColor(name: "Rojo", textColor: Color.white, bgColor: Color(red: 0.6, green: 0, blue: 0), bgColor2: Color(red: 1, green: 0, blue: 0)),
        PlayerColor(name: "Verde", textColor: Color.white, bgColor: Color(red: 0, green: 0.5, blue: 0), bgColor2: Color(red: 0, green: 0.9, blue: 0)),
        PlayerColor(name: "Azul", textColor: Color.white, bgColor: Color(red: 0, green: 0, blue: 0.6), bgColor2: Color(red: 0.3, green: 0.3, blue: 1)),
        PlayerColor(name: "Amarillo", textColor: Color.black, bgColor: Color.yellow, bgColor2: Color(red: 0.6, green: 0.6, blue: 0)),
        PlayerColor(name: "Negro", textColor: Color.white, bgColor: Color.black, bgColor2: Color(red: 0.4, green: 0.4, blue: 0.4)),
        PlayerColor(name: "Blanco", textColor: Color.black, bgColor: Color.white, bgColor2: Color(red: 0.6, green: 0.6, blue: 0.6)),
        PlayerColor(name: "Naranja", textColor: Color.white, bgColor: Color.orange, bgColor2: Color(red: 0.6, green: 0.3, blue: 0)),
        PlayerColor(name: "Violeta", textColor: Color.white, bgColor: Color.purple, bgColor2: Color(red: 0.9, green: 0, blue: 0.9)),
        PlayerColor(name: "Marrón", textColor: Color.white, bgColor: Color.brown, bgColor2: Color(red: 0.9, green: 0.7, blue: 0.5)),
        ]
    
    var players: [Player]
    
    let minPlayers = 2
    let maxPlayers = 8

    init() {
        players = []
        for pc in availablePlayerColors.prefix(4) {
            players.append(Player(playerColor: pc))
        }
    }

    func addPlayer() {
        if players.count < maxPlayers {
            players.append(Player(playerColor: availablePlayerColors[players.count]))
        }
    }
    
    func removePlayer() {
        if players.count > minPlayers {
            players.removeLast()
        }
    }
    
    func changePlayingPlayer(_ player: Player) {
        players.forEach { player in
            player.isPlaying = false
        }
        player.isPlaying = true
    }
}
