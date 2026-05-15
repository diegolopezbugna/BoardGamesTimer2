import Testing
@testable import BoardGamesTimer2

@MainActor
struct GameInProgressViewModelTests {

    private func makeViewModel(playerCount: Int, isLandscape: Bool) -> GameInProgressViewModel {
        let game = Game()
        while game.players.count > playerCount {
            game.removePlayer()
        }
        while game.players.count < playerCount {
            game.addPlayer()
        }
        let vm = GameInProgressViewModel(game: game)
        vm.isLandscape = isLandscape
        return vm
    }

    // MARK: - Initial state

    @Test func initialEndConfirmatingIsFalse() {
        let vm = makeViewModel(playerCount: 4, isLandscape: false)
        #expect(!vm.endConfirmating)
    }

    @Test func isLandscapeToggleUpdatesGrid() {
        let vm = makeViewModel(playerCount: 4, isLandscape: false)
        #expect(vm.rows == 2)
        #expect(vm.columns == 2)
        vm.isLandscape = true
        #expect(vm.rows == 2)
        #expect(vm.columns == 2)
    }

    // MARK: - Portrait

    @Test func portrait2Players() {
        let vm = makeViewModel(playerCount: 2, isLandscape: false)
        #expect(vm.rows == 2)
        #expect(vm.columns == 1)
    }

    @Test func portrait3Players() {
        let vm = makeViewModel(playerCount: 3, isLandscape: false)
        #expect(vm.rows == 3)
        #expect(vm.columns == 1)
    }

    @Test func portrait4Players() {
        let vm = makeViewModel(playerCount: 4, isLandscape: false)
        #expect(vm.rows == 2)
        #expect(vm.columns == 2)
    }

    @Test func portrait5Players() {
        let vm = makeViewModel(playerCount: 5, isLandscape: false)
        #expect(vm.rows == 3)
        #expect(vm.columns == 2)
    }

    @Test func portrait6Players() {
        let vm = makeViewModel(playerCount: 6, isLandscape: false)
        #expect(vm.rows == 3)
        #expect(vm.columns == 2)
    }

    @Test func portrait7Players() {
        let vm = makeViewModel(playerCount: 7, isLandscape: false)
        #expect(vm.rows == 4)
        #expect(vm.columns == 2)
    }

    @Test func portrait8Players() {
        let vm = makeViewModel(playerCount: 8, isLandscape: false)
        #expect(vm.rows == 4)
        #expect(vm.columns == 2)
    }

    // MARK: - Landscape

    @Test func landscape2Players() {
        let vm = makeViewModel(playerCount: 2, isLandscape: true)
        #expect(vm.rows == 1)
        #expect(vm.columns == 2)
    }

    @Test func landscape3Players() {
        let vm = makeViewModel(playerCount: 3, isLandscape: true)
        #expect(vm.rows == 1)
        #expect(vm.columns == 3)
    }

    @Test func landscape4Players() {
        let vm = makeViewModel(playerCount: 4, isLandscape: true)
        #expect(vm.rows == 2)
        #expect(vm.columns == 2)
    }

    @Test func landscape5Players() {
        let vm = makeViewModel(playerCount: 5, isLandscape: true)
        #expect(vm.rows == 2)
        #expect(vm.columns == 3)
    }

    @Test func landscape6Players() {
        let vm = makeViewModel(playerCount: 6, isLandscape: true)
        #expect(vm.rows == 2)
        #expect(vm.columns == 3)
    }

    @Test func landscape7Players() {
        let vm = makeViewModel(playerCount: 7, isLandscape: true)
        #expect(vm.rows == 2)
        #expect(vm.columns == 4)
    }

    @Test func landscape8Players() {
        let vm = makeViewModel(playerCount: 8, isLandscape: true)
        #expect(vm.rows == 2)
        #expect(vm.columns == 4)
    }
}
