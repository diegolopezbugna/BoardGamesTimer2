//
//  GameState.swift
//  BoardGamesTimer2
//

import Foundation
import SwiftUI

struct PlayerColor: Identifiable, Equatable {
    let id: UUID = UUID()
    var name: String
    var textColor: Color
    var bgColor: Color
    var bgColor2: Color
}

struct PlayerState: Identifiable, Equatable {
    let id: UUID
    var playerColor: PlayerColor
    var time: TimeInterval
    var isPlaying: Bool
    var isFirstPlayer: Bool

    init(playerColor: PlayerColor) {
        self.id = UUID()
        self.playerColor = playerColor
        self.time = 0
        self.isPlaying = false
        self.isFirstPlayer = false
    }
}

struct GameState: Equatable {
    var gameType: GameType
    var initialTime: Int
    var perPlayerTime: Int
    var players: [PlayerState]
    var endConfirmating: Bool

    static let availablePlayerColors: [PlayerColor] = [
        PlayerColor(name: "Red",    textColor: .white, bgColor: Color(red: 0.6, green: 0, blue: 0),    bgColor2: Color(red: 1, green: 0, blue: 0)),
        PlayerColor(name: "Green",  textColor: .white, bgColor: Color(red: 0, green: 0.5, blue: 0),    bgColor2: Color(red: 0, green: 0.9, blue: 0)),
        PlayerColor(name: "Blue",   textColor: .white, bgColor: Color(red: 0, green: 0, blue: 0.6),    bgColor2: Color(red: 0.3, green: 0.3, blue: 1)),
        PlayerColor(name: "Yellow", textColor: .black, bgColor: .yellow,                               bgColor2: Color(red: 0.6, green: 0.6, blue: 0)),
        PlayerColor(name: "Black",  textColor: .white, bgColor: .black,                                bgColor2: Color(red: 0.4, green: 0.4, blue: 0.4)),
        PlayerColor(name: "White",  textColor: .black, bgColor: .white,                                bgColor2: Color(red: 0.6, green: 0.6, blue: 0.6)),
        PlayerColor(name: "Orange", textColor: .white, bgColor: .orange,                               bgColor2: Color(red: 0.6, green: 0.3, blue: 0)),
        PlayerColor(name: "Purple", textColor: .white, bgColor: .purple,                               bgColor2: Color(red: 0.9, green: 0, blue: 0.9)),
        PlayerColor(name: "Brown",  textColor: .white, bgColor: .brown,                                bgColor2: Color(red: 0.9, green: 0.7, blue: 0.5)),
    ]

    func gridLayout(isLandscape: Bool) -> (rows: Int, columns: Int) {
        let count = players.count
        let rows: Int
        if count < 4 {
            rows = isLandscape ? 1 : count
        } else {
            rows = isLandscape ? 2 : count / 2 + count % 2
        }
        let columns = Int(ceil(Double(count) / Double(rows)))
        return (rows, columns)
    }

    func remainingColors(for playerID: UUID) -> [PlayerColor] {
        let takenByOthers = players
            .filter { $0.id != playerID }
            .map(\.playerColor)
        return GameState.availablePlayerColors.filter { !takenByOthers.contains($0) }
    }

    static func initial() -> GameState {
        let initialPlayers = availablePlayerColors.prefix(4).map { PlayerState(playerColor: $0) }
        return GameState(
            gameType: .incremental,
            initialTime: InitialPlusTurnTimerPerPlayerGameType.defaultInitialTime,
            perPlayerTime: InitialPlusTurnTimerPerPlayerGameType.defaultPerPlayerTime,
            players: Array(initialPlayers),
            endConfirmating: false
        )
    }
}
