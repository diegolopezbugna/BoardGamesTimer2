import Testing
@testable import BoardGamesTimer2

@MainActor
struct NewGameViewModelTests {

    @Test func playersCountMatchesGame() {
        let game = Game()
        let vm = NewGameViewModel(game: game)
        #expect(vm.playersCount == game.players.count)
    }

    @Test func addPlayerIncreasesPlayersCount() {
        let game = Game()
        let vm = NewGameViewModel(game: game)
        let before = vm.playersCount
        vm.addPlayer()
        #expect(vm.playersCount == before + 1)
    }

    @Test func removePlayerDecreasesPlayersCount() {
        let game = Game()
        let vm = NewGameViewModel(game: game)
        let before = vm.playersCount
        vm.removePlayer()
        #expect(vm.playersCount == before - 1)
    }

    @Test func addPlayerDelegatesToGame() {
        let game = Game()
        let vm = NewGameViewModel(game: game)
        vm.addPlayer()
        #expect(game.players.count == 5)
    }

    @Test func removePlayerDelegatesToGame() {
        let game = Game()
        let vm = NewGameViewModel(game: game)
        vm.removePlayer()
        #expect(game.players.count == 3)
    }

    @Test func addPlayerIsNoOpAtMaxPlayers() {
        let game = Game()
        let vm = NewGameViewModel(game: game)
        for _ in 0..<10 { vm.addPlayer() }
        let countAtMax = vm.playersCount
        vm.addPlayer()
        #expect(vm.playersCount == countAtMax)
    }

    @Test func removePlayerIsNoOpAtMinPlayers() {
        let game = Game()
        let vm = NewGameViewModel(game: game)
        for _ in 0..<10 { vm.removePlayer() }
        let countAtMin = vm.playersCount
        vm.removePlayer()
        #expect(vm.playersCount == countAtMin)
    }
}
