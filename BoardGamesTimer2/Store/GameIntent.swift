//
//  GameIntent.swift
//  BoardGamesTimer2
//

import Foundation

enum GameIntent {
    case setGameType(GameType)
    case setInitialTime(Int)
    case setPerPlayerTime(Int)
    case addPlayer
    case removePlayer
    case selectPreviousColor(playerID: UUID)
    case selectNextColor(playerID: UUID)
    case playerTapped(playerID: UUID)
    case timerTick
    case requestEndGame
    case cancelEndGame
}
