//
//  SpeechView.swift
//  BoardGamesTimer2
//
//  Created by Diego López Bugna on 22/07/2026.
//

import SwiftUI

struct SpeechView: View {
    @State private var manager = SpeechAnalyzeManager()

    var body: some View {
        VStack {
            if manager.isSettingUp {
                ProgressView("Preparando modelo...")
            } else {
                Text("finalized: \(manager.finalizedTranscript)")
                    .padding()
                    .font(.system(size: 10))
                Text("volatile: \(manager.volatileTranscript)")
                    .padding()
                    .font(.system(size: 10))
                    .fontWeight(.light)
//                List(manager.detectedSentences, id: \.self) { Text("• \($0)") }
                Button(manager.isTranscribing ? "Detener" : "Escuchar") {
                    Task {
                        if manager.isTranscribing {
                            try? await manager.stopTranscription()
                        } else {
                            try? await manager.startRealTimeTranscription()
                        }
                    }
                }
            }
        }
        .safeAreaPadding()
        .alert("Error", isPresented: $manager.showError) {
            Button("OK") {}
        } message: {
            Text((manager.error as? Transcriber._Error)?.message ?? "Error desconocido")
        }
    }
}

#Preview {
    SpeechView()
}
