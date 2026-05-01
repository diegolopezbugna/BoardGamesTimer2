//
//  Game.swift
//  BoardGamesTimer2
//
//  Created by Diego López Bugna on 20/04/2026.
//
import Foundation
import SwiftUI

struct PlayerColor : Identifiable, Equatable {
    let id: UUID = UUID()
    
    var name: String
    var textColor: Color
    var bgColor: Color
    var bgColor2: Color
}

@Observable
class Game {
    var gameType: GameType = .incremental
    
    var initialTime = InitialPlusTurnTimerPerPlayerGameType.defaultInitialTime
    var perPlayerTime = InitialPlusTurnTimerPerPlayerGameType.defaultPerPlayerTime
    
    let availablePlayerColors = [
        PlayerColor(name: "Red", textColor: Color.white, bgColor: Color(red: 0.6, green: 0, blue: 0), bgColor2: Color(red: 1, green: 0, blue: 0)),
        PlayerColor(name: "Green", textColor: Color.white, bgColor: Color(red: 0, green: 0.5, blue: 0), bgColor2: Color(red: 0, green: 0.9, blue: 0)),
        PlayerColor(name: "Blue", textColor: Color.white, bgColor: Color(red: 0, green: 0, blue: 0.6), bgColor2: Color(red: 0.3, green: 0.3, blue: 1)),
        PlayerColor(name: "Yellow", textColor: Color.black, bgColor: Color.yellow, bgColor2: Color(red: 0.6, green: 0.6, blue: 0)),
        PlayerColor(name: "Black", textColor: Color.white, bgColor: Color.black, bgColor2: Color(red: 0.4, green: 0.4, blue: 0.4)),
        PlayerColor(name: "White", textColor: Color.black, bgColor: Color.white, bgColor2: Color(red: 0.6, green: 0.6, blue: 0.6)),
        PlayerColor(name: "Orange", textColor: Color.white, bgColor: Color.orange, bgColor2: Color(red: 0.6, green: 0.3, blue: 0)),
        PlayerColor(name: "Purple", textColor: Color.white, bgColor: Color.purple, bgColor2: Color(red: 0.9, green: 0, blue: 0.9)),
        PlayerColor(name: "Brown", textColor: Color.white, bgColor: Color.brown, bgColor2: Color(red: 0.9, green: 0.7, blue: 0.5)),
        ]
    
    var playerColors: [PlayerColor]
    
    let maxPlayers = 8

    init() {
        playerColors = Array(availablePlayerColors.prefix(2))
    }

    func addPlayerColor() {
        if playerColors.count < availablePlayerColors.count {
            playerColors.append(availablePlayerColors[playerColors.count])
        }
    }
    
    func removePlayerColor() {
        if playerColors.count > 0 {
            playerColors.removeLast()
        }
    }
}
