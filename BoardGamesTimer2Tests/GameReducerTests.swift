import Testing
@testable import BoardGamesTimer2

@MainActor
struct GameReducerTests {

    // MARK: - Initial state

    @Test func initialPlayerCount() {
        let state = GameState.initial()
        #expect(state.players.count == 4)
    }

    @Test func initialGameType() {
        let state = GameState.initial()
        #expect(state.gameType == .incremental)
    }

    @Test func initialPlayerColors() {
        let state = GameState.initial()
        for (i, player) in state.players.enumerated() {
            #expect(player.playerColor == GameState.availablePlayerColors[i])
        }
    }

    @Test func initialNoPlayerIsPlaying() {
        let state = GameState.initial()
        #expect(state.players.allSatisfy { !$0.isPlaying })
    }

    @Test func availablePlayerColorsCount() {
        #expect(GameState.availablePlayerColors.count == 9)
    }

    @Test func initialEndConfirmatingIsFalse() {
        let state = GameState.initial()
        #expect(!state.endConfirmating)
    }

    // MARK: - addPlayer

    @Test func addPlayerIncreasesCount() {
        let state = GameState.initial()
        let next = GameReducer.reduce(state: state, intent: .addPlayer)
        #expect(next.players.count == 5)
    }

    @Test func addPlayerStopsAtMax() {
        var state = GameState.initial()
        for _ in 0..<10 {
            state = GameReducer.reduce(state: state, intent: .addPlayer)
        }
        #expect(state.players.count == 8)
    }

    @Test func addPlayerAssignsUnusedColor() {
        let state = GameState.initial()
        let next = GameReducer.reduce(state: state, intent: .addPlayer)
        let usedColors = next.players.dropLast().map(\.playerColor)
        #expect(!usedColors.contains(next.players.last!.playerColor))
    }

    // MARK: - removePlayer

    @Test func removePlayerDecreasesCount() {
        let state = GameState.initial()
        let next = GameReducer.reduce(state: state, intent: .removePlayer)
        #expect(next.players.count == 3)
    }

    @Test func removePlayerStopsAtMin() {
        var state = GameState.initial()
        for _ in 0..<10 {
            state = GameReducer.reduce(state: state, intent: .removePlayer)
        }
        #expect(state.players.count == 2)
    }

    @Test func removePlayerRemovesLastPlayer() {
        let state = GameState.initial()
        let firstPlayerID = state.players[0].id
        let next = GameReducer.reduce(state: state, intent: .removePlayer)
        #expect(next.players[0].id == firstPlayerID)
    }

    // MARK: - playerTapped

    @Test func playerTappedStartsInactivePlayer() {
        let state = GameState.initial()
        let id = state.players[1].id
        let next = GameReducer.reduce(state: state, intent: .playerTapped(playerID: id))
        #expect(next.players.first { $0.id == id }?.isPlaying == true)
    }

    @Test func playerTappedStopsOtherPlayers() {
        var state = GameState.initial()
        let id0 = state.players[0].id
        state = GameReducer.reduce(state: state, intent: .playerTapped(playerID: id0))
        let id1 = state.players[1].id
        let next = GameReducer.reduce(state: state, intent: .playerTapped(playerID: id1))
        #expect(next.players.first { $0.id == id0 }?.isPlaying == false)
        #expect(next.players.first { $0.id == id1 }?.isPlaying == true)
    }

    @Test func playerTappedWhenPlayingPausesPlayer() {
        var state = GameState.initial()
        let id = state.players[0].id
        state = GameReducer.reduce(state: state, intent: .playerTapped(playerID: id))
        let next = GameReducer.reduce(state: state, intent: .playerTapped(playerID: id))
        #expect(next.players.first { $0.id == id }?.isPlaying == false)
    }

    @Test func playerTappedSetsExactlyOneAsPlaying() {
        let state = GameState.initial()
        let id = state.players[2].id
        let next = GameReducer.reduce(state: state, intent: .playerTapped(playerID: id))
        #expect(next.players.filter(\.isPlaying).count == 1)
    }

    // MARK: - timerTick (incremental)

    @Test func timerTickIncrementsPlayingPlayerTime() {
        var state = GameState.initial()
        let id = state.players[0].id
        state = GameReducer.reduce(state: state, intent: .playerTapped(playerID: id))
        let timeBefore = state.players[0].time
        let next = GameReducer.reduce(state: state, intent: .timerTick)
        #expect(next.players[0].time == timeBefore + 1.0)
    }

    @Test func timerTickDoesNotIncrementNonPlayingPlayers() {
        var state = GameState.initial()
        let id = state.players[0].id
        state = GameReducer.reduce(state: state, intent: .playerTapped(playerID: id))
        let next = GameReducer.reduce(state: state, intent: .timerTick)
        for i in 1..<next.players.count {
            #expect(next.players[i].time == 0)
        }
    }

    @Test func timerTickDecrementsForCountdownGameType() {
        var state = GameState.initial()
        state.gameType = .initialPlusTurnTimerPerPlayer
        let id = state.players[0].id
        state = GameReducer.reduce(state: state, intent: .playerTapped(playerID: id))
        let timeBefore = state.players[0].time
        let next = GameReducer.reduce(state: state, intent: .timerTick)
        #expect(next.players[0].time == timeBefore - 1.0)
    }

    // MARK: - endConfirmating dialog

    @Test func requestEndGameSetsEndConfirmating() {
        let state = GameState.initial()
        let next = GameReducer.reduce(state: state, intent: .requestEndGame)
        #expect(next.endConfirmating == true)
    }

    @Test func cancelEndGameClearsEndConfirmating() {
        var state = GameState.initial()
        state = GameReducer.reduce(state: state, intent: .requestEndGame)
        let next = GameReducer.reduce(state: state, intent: .cancelEndGame)
        #expect(next.endConfirmating == false)
    }

    // MARK: - color selection

    @Test func selectNextColorAdvancesColor() {
        let state = GameState.initial()
        let id = state.players[0].id
        let remaining = state.remainingColors(for: id)
        let next = GameReducer.reduce(state: state, intent: .selectNextColor(playerID: id))
        #expect(next.players[0].playerColor == remaining[1])
    }

    @Test func selectPreviousColorIsNoOpAtFirstColor() {
        let state = GameState.initial()
        let id = state.players[0].id
        let colorBefore = state.players[0].playerColor
        let next = GameReducer.reduce(state: state, intent: .selectPreviousColor(playerID: id))
        #expect(next.players[0].playerColor == colorBefore)
    }

    @Test func selectNextColorIsNoOpAtLastColor() {
        var state = GameState.initial()
        let id = state.players[0].id
        // Move to last available color
        let remaining = state.remainingColors(for: id)
        for _ in 0..<(remaining.count - 1) {
            state = GameReducer.reduce(state: state, intent: .selectNextColor(playerID: id))
        }
        let colorAtLast = state.players[0].playerColor
        let next = GameReducer.reduce(state: state, intent: .selectNextColor(playerID: id))
        #expect(next.players[0].playerColor == colorAtLast)
    }

    @Test func remainingColorsExcludesOtherPlayersColors() {
        let state = GameState.initial()
        let id = state.players[0].id
        let remaining = state.remainingColors(for: id)
        let takenByOthers = [GameState.availablePlayerColors[1], GameState.availablePlayerColors[2], GameState.availablePlayerColors[3]]
        for color in takenByOthers {
            #expect(!remaining.contains(color))
        }
    }

    @Test func remainingColorsIncludesCurrentPlayerColor() {
        let state = GameState.initial()
        let id = state.players[0].id
        let remaining = state.remainingColors(for: id)
        #expect(remaining.contains(state.players[0].playerColor))
    }

    @Test func remainingColorsCountWithAllColorsTaken() {
        var state = GameState.initial()
        for _ in 0..<4 {
            state = GameReducer.reduce(state: state, intent: .addPlayer)
        }
        let id = state.players[0].id
        // 8 players: colors 0-7 taken, color 8 (Brown) free
        // remaining for player[0] = [own color, Brown] = 2
        #expect(state.remainingColors(for: id).count == 2)
    }

    // MARK: - Grid layout

    @Test func gridLayoutPortrait2Players() {
        var state = GameState.initial()
        state = GameReducer.reduce(state: state, intent: .removePlayer)
        state = GameReducer.reduce(state: state, intent: .removePlayer)
        let layout = state.gridLayout(isLandscape: false)
        #expect(layout.rows == 2)
        #expect(layout.columns == 1)
    }

    @Test func gridLayoutPortrait3Players() {
        var state = GameState.initial()
        state = GameReducer.reduce(state: state, intent: .removePlayer)
        let layout = state.gridLayout(isLandscape: false)
        #expect(layout.rows == 3)
        #expect(layout.columns == 1)
    }

    @Test func gridLayoutPortrait4Players() {
        let state = GameState.initial()
        let layout = state.gridLayout(isLandscape: false)
        #expect(layout.rows == 2)
        #expect(layout.columns == 2)
    }

    @Test func gridLayoutPortrait5Players() {
        var state = GameState.initial()
        state = GameReducer.reduce(state: state, intent: .addPlayer)
        let layout = state.gridLayout(isLandscape: false)
        #expect(layout.rows == 3)
        #expect(layout.columns == 2)
    }

    @Test func gridLayoutPortrait8Players() {
        var state = GameState.initial()
        for _ in 0..<4 { state = GameReducer.reduce(state: state, intent: .addPlayer) }
        let layout = state.gridLayout(isLandscape: false)
        #expect(layout.rows == 4)
        #expect(layout.columns == 2)
    }

    @Test func gridLayoutLandscape2Players() {
        var state = GameState.initial()
        state = GameReducer.reduce(state: state, intent: .removePlayer)
        state = GameReducer.reduce(state: state, intent: .removePlayer)
        let layout = state.gridLayout(isLandscape: true)
        #expect(layout.rows == 1)
        #expect(layout.columns == 2)
    }

    @Test func gridLayoutLandscape3Players() {
        var state = GameState.initial()
        state = GameReducer.reduce(state: state, intent: .removePlayer)
        let layout = state.gridLayout(isLandscape: true)
        #expect(layout.rows == 1)
        #expect(layout.columns == 3)
    }

    @Test func gridLayoutLandscape4Players() {
        let state = GameState.initial()
        let layout = state.gridLayout(isLandscape: true)
        #expect(layout.rows == 2)
        #expect(layout.columns == 2)
    }

    @Test func gridLayoutLandscape8Players() {
        var state = GameState.initial()
        for _ in 0..<4 { state = GameReducer.reduce(state: state, intent: .addPlayer) }
        let layout = state.gridLayout(isLandscape: true)
        #expect(layout.rows == 2)
        #expect(layout.columns == 4)
    }

    // MARK: - setGameType / setInitialTime / setPerPlayerTime

    @Test func setGameTypeMutatesState() {
        let state = GameState.initial()
        let next = GameReducer.reduce(state: state, intent: .setGameType(.initialPlusTurnTimerPerPlayer))
        #expect(next.gameType == .initialPlusTurnTimerPerPlayer)
    }

    @Test func setInitialTimeMutatesState() {
        let state = GameState.initial()
        let next = GameReducer.reduce(state: state, intent: .setInitialTime(600))
        #expect(next.initialTime == 600)
    }

    @Test func setPerPlayerTimeMutatesState() {
        let state = GameState.initial()
        let next = GameReducer.reduce(state: state, intent: .setPerPlayerTime(30))
        #expect(next.perPlayerTime == 30)
    }
}
