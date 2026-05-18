//
//  GameStore.swift
//  BoardGamesTimer2
//

import Foundation
internal import Combine

@Observable
final class GameStore {
    private(set) var state: GameState
    private var timerCancellable: AnyCancellable?

    init(state: GameState = .initial()) {
        self.state = state
    }

    func send(_ intent: GameIntent) {
        state = GameReducer.reduce(state: state, intent: intent)
        updateTimer()
    }

    func reset() {
        stopTimer()
        state = .initial()
    }

    private func updateTimer() {
        let anyPlaying = state.players.contains { $0.isPlaying }
        if anyPlaying && timerCancellable == nil {
            startTimer()
        } else if !anyPlaying {
            stopTimer()
        }
    }

    private func startTimer() {
        timerCancellable = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.send(.timerTick)
            }
    }

    private func stopTimer() {
        timerCancellable?.cancel()
        timerCancellable = nil
    }
}
