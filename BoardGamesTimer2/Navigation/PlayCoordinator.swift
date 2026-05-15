import SwiftUI

private enum PlayRoute: Hashable {
    case gameInProgress
    case gameResult
}

struct PlayCoordinator: View {
    @State private var path = NavigationPath()
    @State private var game = Game()

    var body: some View {
        NavigationStack(path: $path) {
            NewGameView(game: game, onStart: startGame)
                .navigationDestination(for: PlayRoute.self) { route in
                    switch route {
                    case .gameInProgress:
                        GameInProgressView(game: game, onEnd: endGame)
                    case .gameResult:
                        GameResultView(onNewGame: newGame)
                    }
                }
        }
        .id(ObjectIdentifier(game))
    }

    private func startGame() { path.append(PlayRoute.gameInProgress) }
    private func endGame()   { path.append(PlayRoute.gameResult) }
    private func newGame()   { path = NavigationPath(); game = Game() }
}
