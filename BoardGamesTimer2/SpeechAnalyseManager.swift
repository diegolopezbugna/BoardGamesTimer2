//
//  SpeechAnalyseManager.swift
//  BoardGamesTimer2
//
//  Created by Diego López Bugna on 23/07/2026.
//

import SwiftUI
import Speech
import NaturalLanguage

extension SpeechAnalyzeManager {
    static let defaultLocale = Locale(identifier: "es-AR")
    
    // swiftlint:disable:next type_name
    enum _Error: Error {
        case failToCreateAudioCapturer
        case failToCreateTranscriber
        var message: String {
            switch self {
            case .failToCreateAudioCapturer: "Falló la configuración del motor de audio."
            case .failToCreateTranscriber: "Falló la configuración del speech analyzer."
            }
        }
    }
}

@Observable
class SpeechAnalyzeManager {
    var error: Error? {
        didSet { if error != nil { showError = true } }
    }
    var showError = false

    private(set) var isSettingUp = false
    private(set) var locale: Locale
    private(set) var volatileTranscript: String = ""
    private(set) var finalizedTranscript: String = ""
    private(set) var isTranscribing = false
    private(set) var detectedSentences: [String] = []
    private(set) var lastDetectedSentence = ""

    private var transcriber: Transcriber?
    private var audioCapturer: AudioCapturer?
    private var transcriptionResultsTask: Task<Void, Error>?
    private var audioInputTask: Task<Void, Error>?
    private var audioCapturerState: AudioCapturer.EngineState = .stopped

    init(locale: Locale = SpeechAnalyzeManager.defaultLocale) {
        print("SpeechAnalyzeManager init")
        isSettingUp = true
        self.locale = locale
        Task {
            do {
                try await setupTranscriber(locale: locale)
                try setupAudioCapturer()
                isSettingUp = false
            } catch {
                self.error = error
            }
        }
    }

    deinit {
        print("SpeechAnalyzeManager deinit")
        transcriptionResultsTask?.cancel()
        audioInputTask?.cancel()
        Task { [weak self] in
            await self?.transcriber?.finishAnalysisSession()
        }
    }

    func startRealTimeTranscription() async throws {
        print("Start transcription")
        guard !isTranscribing, audioCapturerState == .stopped else { return }
        guard let transcriber else { throw _Error.failToCreateTranscriber }
        guard let audioCapturer else { throw _Error.failToCreateAudioCapturer }

        try await audioCapturer.startCapturingInput()
        try await transcriber.startRealTimeTranscription()

        resetTranscripts()
        isTranscribing = true
        audioCapturerState = .started
    }

    func stopTranscription() async throws {
        print("Stop transcription")
        audioCapturer?.stopCapturing()
        try await transcriber?.finalizePreviousTranscribing()
        audioCapturerState = .stopped
        isTranscribing = false
    }

    private func setupAudioCapturer() throws {
        print("Setup audio capturer")
        self.audioCapturer = try AudioCapturer()
        self.audioInputTask = Task { [weak self] in
            guard let self = self,
                  let audioCapturer = self.audioCapturer else { return }
            for await (buffer, _) in audioCapturer.inputTapEventsStream {
                if audioCapturerState == .started {
                    self.transcriber?.streamAudioToTranscriber(buffer)
                }
            }
        }
    }

    private func setupTranscriber(locale: Locale) async throws {
        print("Setup transcriber locale: \(locale)")
        self.transcriber = try await Transcriber(locale: locale)

        self.transcriptionResultsTask = Task { [weak self] in
            guard let self = self else { return }
            guard let transcriber else { return }
            do {
                for try await result in transcriber.transcriptionResults {
                    let text = String(result.text.characters)
//                    print(">>>'\(text)'\(result.isFinal ? "<<<" : "")")

                    if result.isFinal {
                        self.finalizedTranscript += text
//                        print(self.finalizedTranscript.count)
                        self.volatileTranscript = ""
                        self.detectSentences(in: finalizedTranscript)
                        self.lastDetectedSentence = detectedSentences.last ?? ""
                        //print(finalizedTranscript)
                    } else {
                        self.volatileTranscript = text
                    }
                }
            } catch {
                if error is CancellationError { return }
                self.error = error
                if self.isTranscribing { try? await self.stopTranscription() }
            }
        }
    }

    private func detectSentences(in text: String) {
//        print("Detecting sentences in: \(text)")
        let tokenizer = NLTokenizer(unit: .sentence)
        tokenizer.string = text
        var sentences: [String] = []
        tokenizer.enumerateTokens(in: text.startIndex..<text.endIndex) { range, _ in
            sentences.append(String(text[range]).trimmingCharacters(in: .whitespaces))
            return true
        }
//        print("  sentences: \(sentences)")
        detectedSentences = sentences
    }

    func resetTranscripts() {
        print("Reset transcripts")
        volatileTranscript = ""
        finalizedTranscript = ""
//        detectedSentences = []
    }
}
