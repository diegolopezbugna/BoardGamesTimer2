import Testing
@testable import BoardGamesTimer2

@MainActor
struct GameTests {

    @Test func initialPlayerCount() {
        let game = Game()
        #expect(game.players.count == 4)
    }

    @Test func initialGameType() {
        let game = Game()
        #expect(game.gameType == .incremental)
    }

    @Test func initialPlayerColors() {
        let game = Game()
        for (i, player) in game.players.enumerated() {
            #expect(player.playerColor == game.availablePlayerColors[i])
        }
    }

    @Test func initialNoPlayerIsPlaying() {
        let game = Game()
        #expect(game.players.allSatisfy { !$0.isPlaying })
    }

    @Test func availablePlayerColorsCount() {
        let game = Game()
        #expect(game.availablePlayerColors.count == 9)
    }

    @Test func addPlayerIncreasesCount() {
        let game = Game()
        game.addPlayer()
        #expect(game.players.count == 5)
    }

    @Test func addPlayerStopsAtMax() {
        let game = Game()
        for _ in 0..<10 {
            game.addPlayer()
        }
        #expect(game.players.count == game.maxPlayers)
    }

    @Test func removePlayerDecreasesCount() {
        let game = Game()
        game.removePlayer()
        #expect(game.players.count == 3)
    }

    @Test func removePlayerStopsAtMin() {
        let game = Game()
        for _ in 0..<10 {
            game.removePlayer()
        }
        #expect(game.players.count == game.minPlayers)
    }

    @Test func removePlayerRemovesLastPlayer() {
        let game = Game()
        let firstPlayer = game.players[0]
        game.removePlayer()
        #expect(game.players[0] == firstPlayer)
    }

    @Test func changePlayingPlayerSetsExactlyOne() {
        let game = Game()
        game.changePlayingPlayer(game.players[1])
        let playingCount = game.players.filter(\.isPlaying).count
        #expect(playingCount == 1)
        #expect(game.players[1].isPlaying)
    }

    @Test func changePlayingPlayerClearsOthers() {
        let game = Game()
        game.players[0].isPlaying = true
        game.changePlayingPlayer(game.players[2])
        #expect(!game.players[0].isPlaying)
        #expect(game.players[2].isPlaying)
    }

    @Test func changePlayingPlayerWhenAlreadyPlaying() {
        let game = Game()
        game.changePlayingPlayer(game.players[0])
        game.changePlayingPlayer(game.players[0])
        let playingCount = game.players.filter(\.isPlaying).count
        #expect(playingCount == 1)
        #expect(game.players[0].isPlaying)
    }

    @Test func addPlayerAssignsNextColor() {
        let game = Game()
        game.addPlayer()
        // addPlayer uses availablePlayerColors[players.count] before appending
        #expect(game.players[4].playerColor == game.availablePlayerColors[4])
    }
}
