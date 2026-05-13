# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Build & Test

This is a pure Xcode/Swift project — no Makefile or package manager scripts. All `xcodebuild` commands must be run from the `BoardGamesTimer2/` subdirectory (where the `.xcodeproj` lives).

```bash
# Build
xcodebuild build -scheme BoardGamesTimer2 -destination 'platform=iOS Simulator,name=iPhone 16'

# Run all tests (unit + UI)
xcodebuild test -scheme BoardGamesTimer2 -destination 'platform=iOS Simulator,name=iPhone 16'

# Run only unit tests
xcodebuild test -scheme BoardGamesTimer2 -only-testing:BoardGamesTimer2Tests -destination 'platform=iOS Simulator,name=iPhone 16'

# Run a single test (Swift Testing uses StructName/methodName)
xcodebuild test -scheme BoardGamesTimer2 -only-testing:BoardGamesTimer2Tests/GameTests/initialPlayerCount -destination 'platform=iOS Simulator,name=iPhone 16'
```

There is a single shared scheme (`BoardGamesTimer2`); `BoardGamesTimer2Tests` and `BoardGamesTimer2UITests` are test *targets*, not schemes. Tests use Swift Testing (`import Testing`, `@Test`, `#expect`) rather than XCTest.

## Architecture

SwiftUI + MVVM iOS/iPadOS app. No UIKit. Uses `@Observable` (Swift 5.9 macro) rather than `ObservableObject`/`@Published`.

**Dependency**: Lottie (airbnb/lottie-spm) for animations — resolved via Swift Package Manager.

### Navigation flow

```
HomeView (TabView)
├── "Play" tab → NewGameView → GameInProgressView → GameResultView (stub)
├── "Players" tab → PlayersView
├── "Plays" tab → (stub)
└── "Settings" tab → (stub)
```

### State management

- `Game` and `Player` are `@Observable` model classes — the single source of truth. `PlayerColor` is a struct defined in `Game.swift`.
- ViewModels (`NewGameViewModel`, `GameInProgressViewModel`, `SelectPlayerColorViewModel`) hold UI-specific logic and are created as `@State` in the owning view.
- Views receive the shared `Game` instance through navigation (passed directly, not via environment).
- `SelectPlayerColorViewModel` filters `game.availablePlayerColors` to exclude colors already chosen by other players.

### Game types

- **Incremental**: time counts up for the active player.
- **Initial + Turn**: each player has a configurable initial pool plus per-turn bonus; time counts down. Configured via `game.initialTime` and `game.perPlayerTime`.

`ProgressPlayerView` drives its own 1-second timer via `Timer.publish` and mutates `player.time` directly (`+1` incremental, `-1` countdown). Tapping an active player pauses them; tapping an inactive player calls `game.changePlayingPlayer(_:)` which deactivates all others first.

### Layout

`GameInProgressViewModel` computes `rows`/`columns` from player count and an `isLandscape` flag (set externally by the view via `@Environment(\.verticalSizeClass)`). Portrait: up to 3 players stack in a single column; 4+ use two columns. Landscape: up to 3 players in a single row; 4+ use two rows.
