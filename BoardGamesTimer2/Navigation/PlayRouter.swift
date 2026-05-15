import SwiftUI

enum PlayRoute: Hashable {
    case gameInProgress
    case gameResult
}

@Observable
final class PlayRouter {
    var path = NavigationPath()
    private(set) var game = Game()

    func startGame() { path.append(PlayRoute.gameInProgress) }
    func endGame()   { path.append(PlayRoute.gameResult) }
    func newGame()   { path = NavigationPath(); game = Game() }
}
