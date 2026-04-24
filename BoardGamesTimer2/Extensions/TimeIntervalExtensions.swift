//
//  TimeIntervalExtensions.swift
//  BoardGamesTimer2
//
//  Created by Diego López Bugna on 20/04/2026.
//
import Foundation

extension TimeInterval {
    func toString(showMs: Bool) -> String {
        let ti = NSInteger(self)
        let ms = Int(self.truncatingRemainder(dividingBy: 1) * 1000)
        let seconds = ti % 60
        let minutes = (ti / 60) % 60
        let hours = (ti / 3600)
        
        if (showMs) {
            if (hours > 0) {
                return String(format: "%0.2d:%0.2d:%0.2d.%0.3d",hours,minutes,seconds,ms)
            }
            else {
                return String(format: "%0.2d:%0.2d.%0.3d",minutes,seconds,ms)
            }
        }
        else {
            if (hours > 0) {
                return String(format: "%0.2d:%0.2d:%0.2d",hours,minutes,seconds)
            }
            else {
                return String(format: "%0.2d:%0.2d",minutes,seconds)
            }
        }
    }
}
