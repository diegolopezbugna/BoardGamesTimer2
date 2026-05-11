//
//  PlayersView.swift
//  BoardGamesTimer2
//
//  Created by Diego López Bugna on 11/05/2026.
//

import SwiftUI
import Lottie

struct PlayersView: View {
    @State var playbackMode: LottiePlaybackMode = LottiePlaybackMode.paused

    let lottieUrl = URL(string: "https://assets10.lottiefiles.com/packages/lf20_touohxv0.json")

    var body: some View {
        VStack {
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            LottieView {
                await LottieAnimation.loadedFrom(url: lottieUrl!)
            }
            .playbackMode(playbackMode)
            .animationDidFinish { _ in
                playbackMode = LottiePlaybackMode.paused
            }
        }
        .onAppear() {
            playbackMode = LottiePlaybackMode.playing(.fromProgress(0, toProgress: 1, loopMode: .playOnce))
        }
    }
}

#Preview {
    PlayersView()
}
