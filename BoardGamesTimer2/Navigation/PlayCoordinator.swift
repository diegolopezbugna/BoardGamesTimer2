import SwiftUI

private enum PlayRoute: Hashable {
    case gameInProgress
    case gameResult
}

struct PlayCoordinator: View {
    @State private var path = NavigationPath()
    @State private var store = GameStore()

    var body: some View {
        NavigationStack(path: $path) {
            NewGameView(store: store, onStart: startGame)
                .navigationDestination(for: PlayRoute.self) { route in
                    switch route {
                    case .gameInProgress:
                        GameInProgressView(store: store, onEnd: endGame)
                    case .gameResult:
                        GameResultView(onNewGame: newGame)
                    }
                }
        }
    }

    private func startGame() { path.append(PlayRoute.gameInProgress) }
    private func endGame()   { path.append(PlayRoute.gameResult) }
    private func newGame()   { path = NavigationPath(); store.reset() }
}
