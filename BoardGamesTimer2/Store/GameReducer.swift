//
//  GameReducer.swift
//  BoardGamesTimer2
//

import Foundation

enum GameReducer {
    static func reduce(state: GameState, intent: GameIntent) -> GameState {
        var next = state

        switch intent {
        case .setGameType(let type):
            next.gameType = type

        case .setInitialTime(let t):
            next.initialTime = t

        case .setPerPlayerTime(let t):
            next.perPlayerTime = t

        case .addPlayer:
            guard next.players.count < 8 else { break }
            let usedColorIDs = Set(next.players.map(\.playerColor.id))
            if let nextColor = GameState.availablePlayerColors.first(where: { !usedColorIDs.contains($0.id) }) {
                next.players.append(PlayerState(playerColor: nextColor))
            }

        case .removePlayer:
            guard next.players.count > 2 else { break }
            next.players.removeLast()

        case .selectPreviousColor(let playerID):
            next = applyColorChange(in: next, playerID: playerID, direction: -1)

        case .selectNextColor(let playerID):
            next = applyColorChange(in: next, playerID: playerID, direction: +1)

        case .playerTapped(let playerID):
            let isCurrentlyPlaying = next.players.first { $0.id == playerID }?.isPlaying ?? false
            if isCurrentlyPlaying {
                next.players = next.players.map { p in
                    guard p.id == playerID else { return p }
                    var m = p; m.isPlaying = false; return m
                }
            } else {
                next.players = next.players.map { p in
                    var m = p
                    m.isPlaying = (p.id == playerID)
                    return m
                }
            }

        case .timerTick:
            let delta: TimeInterval = next.gameType == .incremental ? 1.0 : -1.0
            next.players = next.players.map { p in
                guard p.isPlaying else { return p }
                var m = p
                m.time += delta
                return m
            }

        case .requestEndGame:
            next.endConfirmating = true

        case .cancelEndGame:
            next.endConfirmating = false
        }

        return next
    }

    private static func applyColorChange(in state: GameState, playerID: UUID, direction: Int) -> GameState {
        var next = state
        guard let idx = next.players.firstIndex(where: { $0.id == playerID }) else { return next }
        let remaining = next.remainingColors(for: playerID)
        let currentColor = next.players[idx].playerColor
        guard let colorIdx = remaining.firstIndex(of: currentColor) else { return next }
        let newColorIdx = colorIdx + direction
        guard newColorIdx >= 0 && newColorIdx < remaining.count else { return next }
        next.players[idx].playerColor = remaining[newColorIdx]
        return next
    }
}
