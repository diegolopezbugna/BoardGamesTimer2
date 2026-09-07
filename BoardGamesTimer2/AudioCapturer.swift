//
//  AudioCapturer.swift
//  BoardGamesTimer2
//
//  Created by Diego López Bugna on 23/07/2026.
//

import SwiftUI
import AVFAudio

extension AudioCapturer {
    enum EngineState {
        case started, paused, stopped
    }

    enum _Error: Error {
        case permissionDenied
        case unknownPermission
        case builtinMicNotFound
//        case inputNotEnabled

        var message: String {
            switch self {
            case .permissionDenied: "Permiso de micrófono denegado."
            case .unknownPermission: "Permiso de micrófono desconocido."
            case .builtinMicNotFound: "No se encontró el micrófono integrado."
//            case .inputNotEnabled: "El input de audio no está disponible."
            }
        }
    }
}

// nonisolated porque installTap crashea si se llama desde el main thread
nonisolated class AudioCapturer {
    let inputTapEventsStream: AsyncStream<(AVAudioPCMBuffer, AVAudioTime)>
    private let inputTapEventsContinuation: AsyncStream<(AVAudioPCMBuffer, AVAudioTime)>.Continuation

    private let audioEngine = AVAudioEngine()
    private let audioSession = AVAudioSession.sharedInstance()
    private let bufferSize: UInt32 = 1024

    init() throws {
        (inputTapEventsStream, inputTapEventsContinuation) = AsyncStream.makeStream(of: (AVAudioPCMBuffer, AVAudioTime).self)
        try configureAudioSession()
    }

    private func configureAudioSession() throws {
        try audioSession.setCategory(.playAndRecord, mode: .measurement, options: [.duckOthers, .defaultToSpeaker, .allowBluetoothHFP])
        try audioSession.setActive(true, options: .notifyOthersOnDeactivation)

        guard let availableInputs = audioSession.availableInputs,
              let builtInMic = availableInputs.first(where: { $0.portType == .builtInMic }) else {
            throw _Error.builtinMicNotFound
        }
        try audioSession.setPreferredInput(builtInMic)
    }

    func startCapturingInput() async throws {
        try await checkRecordingPermission()
        audioEngine.reset()

        let inputNode = audioEngine.inputNode
        //guard inputNode.isEnabled else { throw _Error.inputNotEnabled }

        let format = inputNode.outputFormat(forBus: 0)
        inputNode.removeTap(onBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: bufferSize, format: format) { buffer, time in
            self.inputTapEventsContinuation.yield((buffer, time))
        }

        audioEngine.prepare()
        try audioEngine.start()
    }

    func pauseCapturing() {
        audioEngine.pause()
    }
    
    func resumeCapturing() throws {
        try audioEngine.start()
    }

    func stopCapturing() {
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
        audioEngine.reset()
    }

    private func checkRecordingPermission() async throws {
        switch AVAudioApplication.shared.recordPermission {
        case .undetermined:
            guard await AVAudioApplication.requestRecordPermission() else {
                throw _Error.permissionDenied
            }
        case .denied:
            throw _Error.permissionDenied
        case .granted:
            return
        @unknown default:
            throw _Error.unknownPermission
        }
    }
}
