//
//  GameType.swift
//  BoardGamesTimer2
//
//  Created by Diego López Bugna on 20/04/2026.
//
import Foundation

enum GameType: String, CaseIterable, Identifiable {
    var id: Self { self }
    
    case incremental = "Incremental"
    case initialPlusTurnTimerPerPlayer = "Initial + turn"
}

struct InitialPlusTurnTimerPerPlayerGameType {
    static let defaultInitialTime = 3 * 60
    static let defaultPerPlayerTime = 20
}
