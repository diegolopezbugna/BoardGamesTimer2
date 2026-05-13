import SwiftUI
import Testing
@testable import BoardGamesTimer2

// PlayerColor is a value type whose UUID is assigned once at creation.
// All tests use a local dummy color to keep PlayerTests independent of Game.
private let dummyColor = PlayerColor(name: "Test", textColor: .white, bgColor: .black, bgColor2: .gray)
private let otherColor = PlayerColor(name: "Other", textColor: .black, bgColor: .white, bgColor2: .gray)

@MainActor
struct PlayerTests {

    @Test func defaultTime() {
        let player = Player(playerColor: dummyColor)
        #expect(player.time == 0.0)
    }

    @Test func defaultIsNotPlaying() {
        let player = Player(playerColor: dummyColor)
        #expect(!player.isPlaying)
    }

    @Test func defaultIsNotFirstPlayer() {
        let player = Player(playerColor: dummyColor)
        #expect(!player.isFirstPlayer)
    }

    @Test func initializerSetsColor() {
        let player = Player(playerColor: dummyColor)
        #expect(player.playerColor == dummyColor)
    }

    @Test func distinctInstancesAreNotEqual() {
        // Each Player gets a unique UUID id, so two instances are never equal
        let a = Player(playerColor: dummyColor)
        let b = Player(playerColor: dummyColor)
        #expect(a != b)
    }

    @Test func sameInstanceIsEqual() {
        let player = Player(playerColor: dummyColor)
        #expect(player == player)
    }

    @Test func isPlayingMutation() {
        let player = Player(playerColor: dummyColor)
        player.isPlaying = true
        #expect(player.isPlaying)
    }

    @Test func isFirstPlayerMutation() {
        let player = Player(playerColor: dummyColor)
        player.isFirstPlayer = true
        #expect(player.isFirstPlayer)
    }

    @Test func playerColorMutation() {
        let player = Player(playerColor: dummyColor)
        player.playerColor = otherColor
        #expect(player.playerColor == otherColor)
    }
}
