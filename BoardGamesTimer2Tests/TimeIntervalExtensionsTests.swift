import Foundation
import Testing
@testable import BoardGamesTimer2

struct TimeIntervalExtensionsTests {

    // MARK: - Without milliseconds

    @Test func zeroNoMs() {
        #expect(TimeInterval(0.0).toString(showMs: false) == "00:00")
    }

    @Test func secondsOnlyNoMs() {
        #expect(TimeInterval(65.0).toString(showMs: false) == "01:05")
    }

    @Test func justUnderOneHourNoMs() {
        #expect(TimeInterval(3599.0).toString(showMs: false) == "59:59")
    }

    @Test func exactlyOneHourNoMs() {
        #expect(TimeInterval(3600.0).toString(showMs: false) == "01:00:00")
    }

    @Test func hoursShownNoMs() {
        #expect(TimeInterval(3661.0).toString(showMs: false) == "01:01:01")
    }

    // Fractional seconds are truncated (not rounded) when showMs is false.
    @Test func fractionalSecondsAreTruncatedNoMs() {
        #expect(TimeInterval(65.9).toString(showMs: false) == "01:05")
    }

    // MARK: - With milliseconds

    @Test func zeroWithMs() {
        #expect(TimeInterval(0.0).toString(showMs: true) == "00:00.000")
    }

    @Test func secondsOnlyWithMs() {
        #expect(TimeInterval(65.5).toString(showMs: true) == "01:05.500")
    }

    @Test func subSecondPrecision() {
        #expect(TimeInterval(0.999).toString(showMs: true) == "00:00.999")
    }

    @Test func hoursShownWithMs() {
        #expect(TimeInterval(3661.25).toString(showMs: true) == "01:01:01.250")
    }
}
