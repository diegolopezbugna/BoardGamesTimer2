//
//  Transcriber.swift
//  BoardGamesTimer2
//
//  Created by Diego López Bugna on 23/07/2026.
//

import SwiftUI
import Speech

extension Transcriber {
    // swiftlint:disable:next type_name
    enum _Error: Error {
        case notAvailable
        case localeNotSupported
        case audioConverterCreationFailed
        case failedToConvertBuffer(String?)

        var message: String {
            switch self {
            case .notAvailable: "El transcriber no está disponible en este dispositivo."
            case .localeNotSupported: "El locale elegido no está soportado."
            case .audioConverterCreationFailed: "No se pudo crear el conversor de audio."
            case .failedToConvertBuffer(let s): "Falló la conversión del buffer. \(s ?? "")"
            }
        }
    }
}

class Transcriber {
    let transcriptionResults: any AsyncSequence<SpeechTranscriber.Result, any Error>

    private let analyzer: SpeechAnalyzer
    private let transcriber: SpeechTranscriber
    private var bestAvailableAudioFormat: AVAudioFormat?

    private var inputStream: AsyncStream<AnalyzerInput>?
    private var inputContinuation: AsyncStream<AnalyzerInput>.Continuation?

    private let preset: SpeechTranscriber.Preset = .timeIndexedProgressiveTranscription
    private let locale: Locale
    private var audioConverter: AVAudioConverter?

    init(locale: Locale) async throws {
        guard SpeechTranscriber.isAvailable else { throw _Error.notAvailable }

        guard let resolvedLocale = await SpeechTranscriber.supportedLocale(equivalentTo: locale) else {
            throw _Error.localeNotSupported
        }
        self.locale = resolvedLocale

        try await AssetInventory.reserve(locale: resolvedLocale)

        transcriber = SpeechTranscriber(
            locale: resolvedLocale,
            transcriptionOptions: preset.transcriptionOptions,
            reportingOptions: preset.reportingOptions.union([.alternativeTranscriptions]),
            attributeOptions: preset.attributeOptions.union([.transcriptionConfidence])
        )
        transcriptionResults = transcriber.results

        analyzer = SpeechAnalyzer(modules: [transcriber], options: .init(priority: .userInitiated, modelRetention: .processLifetime))
        bestAvailableAudioFormat = await SpeechAnalyzer.bestAvailableAudioFormat(compatibleWith: [transcriber])

        try await analyzer.prepareToAnalyze(in: bestAvailableAudioFormat, withProgressReadyHandler: nil)

        let installed = await SpeechTranscriber.installedLocales.contains(resolvedLocale)
        if !installed {
            if let request = try await AssetInventory.assetInstallationRequest(supporting: [transcriber]) {
                try await request.downloadAndInstall()
            }
        }
    }

    deinit {
        Task { [weak self] in
            await self?.finishAnalysisSession()
        }
    }

    func finishAnalysisSession() async {
        inputContinuation?.finish()
        await analyzer.cancelAndFinishNow()
        await AssetInventory.release(reservedLocale: locale)
    }

    func startRealTimeTranscription() async throws {
        try await finalizePreviousTranscribing()
        (inputStream, inputContinuation) = AsyncStream<AnalyzerInput>.makeStream()
        try await analyzer.start(inputSequence: inputStream!)
    }

    func streamAudioToTranscriber(_ buffer: AVAudioPCMBuffer) {
        let format = bestAvailableAudioFormat ?? buffer.format
        var convertedBuffer = buffer
        do {
            convertedBuffer = try convertBuffer(buffer, to: format)
        } catch {
            print("error convirtiendo buffer: \(error)")
        }
        inputContinuation?.yield(AnalyzerInput(buffer: convertedBuffer))
    }

    func convertBuffer(_ buffer: AVAudioPCMBuffer, to format: AVAudioFormat) throws -> AVAudioPCMBuffer {
        let inputFormat = buffer.format
        guard inputFormat != format else { return buffer }

        if audioConverter == nil || audioConverter?.outputFormat != format {
            audioConverter = AVAudioConverter(from: inputFormat, to: format)
            audioConverter?.primeMethod = .none
        }
        guard let audioConverter else { throw _Error.audioConverterCreationFailed }

        let ratio = audioConverter.outputFormat.sampleRate / audioConverter.inputFormat.sampleRate
        let frameCapacity = AVAudioFrameCount((Double(buffer.frameLength) * ratio).rounded(.up))
        guard let conversionBuffer = AVAudioPCMBuffer(pcmFormat: audioConverter.outputFormat, frameCapacity: frameCapacity) else {
            throw _Error.failedToConvertBuffer("No se pudo crear AVAudioPCMBuffer.")
        }

        var nsError: NSError?
        var bufferProcessed = false
        let status = audioConverter.convert(to: conversionBuffer, error: &nsError) { _, inputStatusPointer in
            defer { bufferProcessed = true }
            inputStatusPointer.pointee = bufferProcessed ? .noDataNow : .haveData
            return bufferProcessed ? nil : buffer
        }

        guard status != .error else {
            throw _Error.failedToConvertBuffer(nsError?.localizedDescription)
        }
        return conversionBuffer
    }

    func finalizePreviousTranscribing() async throws {
        inputContinuation?.finish()
        inputStream = nil
        inputContinuation = nil
        try await analyzer.finalize(through: nil)
    }
}
