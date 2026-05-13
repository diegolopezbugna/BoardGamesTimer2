import Testing
@testable import BoardGamesTimer2

// Game starts with 4 players: Red(0), Green(1), Blue(2), Yellow(3)
// availablePlayerColors: Red(0), Green(1), Blue(2), Yellow(3), Black(4), White(5), Orange(6), Purple(7), Brown(8)
// For player[0] (Red): remainingPlayerColors = [Red, Black, White, Orange, Purple, Brown]

@MainActor
struct SelectPlayerColorViewModelTests {

    @Test func remainingColorsExcludesOtherPlayersColors() {
        let game = Game()
        let player = game.players[0]
        let vm = SelectPlayerColorViewModel(game: game, player: player)

        let remaining = vm.remainingPlayerColors
        let takenByOthers = [game.availablePlayerColors[1], game.availablePlayerColors[2], game.availablePlayerColors[3]]
        for color in takenByOthers {
            #expect(!remaining.contains(color))
        }
    }

    @Test func remainingColorsIncludesCurrentPlayerColor() {
        let game = Game()
        let player = game.players[0]
        let vm = SelectPlayerColorViewModel(game: game, player: player)

        #expect(vm.remainingPlayerColors.contains(player.playerColor))
    }

    @Test func remainingColorsIncludesUnassignedColors() {
        let game = Game()
        let player = game.players[0]
        let vm = SelectPlayerColorViewModel(game: game, player: player)

        // Black (index 4) is unassigned in a 4-player game
        #expect(vm.remainingPlayerColors.contains(game.availablePlayerColors[4]))
    }

    // previousDisabled is true when the player is at the first color in remainingPlayerColors
    @Test func previousDisabledWhenAtFirstRemainingColor() {
        let game = Game()
        let player = game.players[0] // Red = first of remainingPlayerColors
        let vm = SelectPlayerColorViewModel(game: game, player: player)

        #expect(vm.previousDisabled)
    }

    // Even if a player is not at the first availablePlayerColor, previousDisabled is true
    // when they are at the first *remaining* color — this was the bug: it previously
    // compared against availablePlayerColors.first instead of remainingPlayerColors.first.
    @Test func previousDisabledWhenAtFirstRemainingColorButNotFirstAvailable() {
        let game = Game()
        // Fill to 8 players: Red(0)…Purple(7) taken; Brown(8) free.
        // For player[0] (Red): remainingPlayerColors = [Red, Brown].
        // Move player[0] to Brown — Brown is remainingPlayerColors.last, not .first,
        // so first move player[0] to Brown then check player[1] (Green):
        // For player[1] (Green): remainingPlayerColors = [Red, Green, Brown].
        // Move player[1] to Brown (last remaining).
        // Now move player[1] to Red (index 0 of remaining [Red, Green, Brown]).
        // Actually let's use a simpler setup:
        // 3-player game: Red(0), Green(1), Blue(2) taken. Remaining for player[0] =
        // [Red, Yellow, Black, White, Orange, Purple, Brown].
        // First remaining = Red. Move to Yellow (index 1). Previous should be enabled.
        // Now remove until 2 players, add one = 3 players is achieved differently.
        // Simplest: use default 4-player game, player[1] has Green.
        // remainingForPlayer1 = [Red(free? no — Red taken by player0), Green, Black, White, Orange, Purple, Brown]
        // Wait: Red is taken by player[0], so for player[1]:
        // remainingPlayerColors = [Green, Black, White, Orange, Purple, Brown]
        // first remaining = Green (not first available = Red)
        // previousDisabled for player[1] at Green should be true (at first remaining)
        let player = game.players[1] // Green
        let vm = SelectPlayerColorViewModel(game: game, player: player)
        // player[1] is at Green, which is remainingPlayerColors.first for player[1]
        // (Red is taken by player[0], so remaining starts at Green)
        #expect(vm.previousDisabled)
    }

    @Test func previousNotDisabledWhenNotAtFirstRemainingColor() {
        let game = Game()
        let player = game.players[0] // Red = first remaining
        let vm = SelectPlayerColorViewModel(game: game, player: player)
        vm.next() // moves to Black (index 1 of remaining)
        #expect(!vm.previousDisabled)
    }

    // nextDisabled is true when the player is at the last color in remainingPlayerColors
    @Test func nextDisabledWhenAtLastRemainingColor() {
        let game = Game()
        let player = game.players[0]
        let vm = SelectPlayerColorViewModel(game: game, player: player)
        // Move to the last remaining color
        while !vm.nextDisabled {
            vm.next()
        }
        #expect(vm.nextDisabled)
        #expect(player.playerColor == vm.remainingPlayerColors.last)
    }

    @Test func nextNotDisabledWhenNotAtLastRemainingColor() {
        let game = Game()
        let player = game.players[0] // Red, not last remaining
        let vm = SelectPlayerColorViewModel(game: game, player: player)

        #expect(!vm.nextDisabled)
    }

    @Test func nextMovesToNextRemainingColor() {
        let game = Game()
        let player = game.players[0]
        let vm = SelectPlayerColorViewModel(game: game, player: player)

        let expectedNext = vm.remainingPlayerColors[1]
        vm.next()

        #expect(player.playerColor == expectedNext)
    }

    @Test func previousMovesToPreviousRemainingColor() {
        let game = Game()
        let player = game.players[0]
        let vm = SelectPlayerColorViewModel(game: game, player: player)

        vm.next() // move to index 1
        let currentIndex = vm.remainingPlayerColors.firstIndex(of: player.playerColor)!
        let expectedPrev = vm.remainingPlayerColors[currentIndex - 1]
        vm.previous()

        #expect(player.playerColor == expectedPrev)
    }

    @Test func nextIsNoOpAtLastRemainingColor() {
        let game = Game()
        let player = game.players[0]
        let vm = SelectPlayerColorViewModel(game: game, player: player)

        // Navigate to the last remaining color via the VM so remainingPlayerColors stays consistent
        while !vm.nextDisabled {
            vm.next()
        }
        let colorBefore = player.playerColor
        vm.next()

        #expect(player.playerColor == colorBefore)
    }

    @Test func previousIsNoOpAtFirstRemainingColor() {
        let game = Game()
        let player = game.players[0] // Red = first remaining color
        let vm = SelectPlayerColorViewModel(game: game, player: player)

        let colorBefore = player.playerColor
        vm.previous()

        #expect(player.playerColor == colorBefore)
    }

    @Test func remainingColorsCountWithAllOtherColorsTaken() {
        let game = Game()
        while game.players.count < 8 {
            game.addPlayer()
        }
        // players[0..7] have colors [0..7]; color[8] (Brown) is unassigned
        let player = game.players[0]
        let vm = SelectPlayerColorViewModel(game: game, player: player)

        // remaining = [Red (own), Brown (unassigned)] = 2
        #expect(vm.remainingPlayerColors.count == 2)
    }
}
