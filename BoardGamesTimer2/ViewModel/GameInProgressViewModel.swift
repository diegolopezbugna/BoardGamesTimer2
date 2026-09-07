//
//  GameInProgressViewModel.swift
//  BoardGamesTimer2
//
//  Created by Diego López Bugna on 07/05/2026.
//

import Foundation

@MainActor
@Observable
class GameInProgressViewModel {
    var game: Game
    var endConfirmating = false
    var isLandscape = false
    var speechAnalyseManager = SpeechAnalyzeManager()

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
        Task {
            do {
                try await Task.sleep(for: .seconds(2))
                print(self.speechAnalyseManager.isSettingUp)
                try await self.speechAnalyseManager.startRealTimeTranscription()
            } catch {
                print(error)
            }
            //self.speechAnalyseManager.volatileTranscript
            self.observeSpeechAnalyseManager()
        }
    }
    
    func observeSpeechAnalyseManager() {
        _ = withObservationTracking {
            self.speechAnalyseManager.finalizedTranscript
        } onChange: {
            Task { @MainActor in
                try await Task.sleep(nanoseconds: 100)
                self.resolveIntentFrom(sentence: self.speechAnalyseManager.lastDetectedSentence)
                self.observeSpeechAnalyseManager()
            }
        }

    }
    
    func resolveIntentFrom(sentence: String) {
//        print("resolveIntentFrom: '\(sentence)'")
        for player in game.players {
            if sentenceMatchesPlayer(sentence, player) {
//                player.isPlaying = true
                game.changePlayingPlayer(player)
            }
        }
    }
    
    func sentenceMatchesPlayer(_ sentence: String, _ player: Player) -> Bool {
        return sentence.localizedCaseInsensitiveContains(player.name) ||
            sentence.localizedCaseInsensitiveContains(player.playerColor.name)
    }
}
