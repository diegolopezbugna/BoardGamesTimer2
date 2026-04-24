//
//  InitialPlusNewGameView.swift
//  BoardGamesTimer2
//
//  Created by Diego López Bugna on 20/04/2026.
//

import SwiftUI

struct InitialPlusNewGameView: View {
    @Binding var initialTime: Int
    private let maxInitialTime = 24 * 60 * 60
    @Binding var perPlayerTime: Int
    private let maxPerPlayerTime = 10 * 60

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Initial time")
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.trailing)
                HStack {
                    Text(TimeInterval(initialTime).toString(showMs: false))
                    Stepper("", value: $initialTime, in: 0...maxInitialTime, step: 30)
                        .labelsHidden()
                }
            }
            Spacer()
            VStack(alignment: .trailing) {
                Text("Per player")
                    .fontWeight(.semibold)
                HStack {
                    Text("+ \(TimeInterval(perPlayerTime).toString(showMs: false))")
                    Stepper("", value: $perPlayerTime, in: 0...maxPerPlayerTime, step: 5)
                        .labelsHidden()
                }
            }
        }
    }
}

#Preview {
    InitialPlusNewGameView(initialTime: .constant(InitialPlusTurnTimerPerPlayerGameType.defaultInitialTime), perPlayerTime: .constant(InitialPlusTurnTimerPerPlayerGameType.defaultPerPlayerTime))
}
