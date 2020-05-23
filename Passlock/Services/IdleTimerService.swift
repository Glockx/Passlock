//
//  IdleTimerService.swift
//  Passlock
//
//  Created by Muzaffarli Nijat on 2020/05/23.
//  Copyright © 2020 Muzaffarli Nijat. All rights reserved.
//

import Foundation
import UIKit

class TimerUIApplication: UIApplication {
    static let ApplicationDidTimoutNotification = "AppTimout"

    // The timeout in seconds for when to fire the idle timer.
    let timeoutInSeconds: TimeInterval = 5 * 60

    var idleTimer: Timer?

    // Resent the timer because there was user interaction.
    func resetIdleTimer() {
        if let idleTimer = idleTimer {
            idleTimer.invalidate()
        }

        idleTimer = Timer.scheduledTimer(timeInterval: timeoutInSeconds, target: self, selector: #selector(TimerUIApplication.idleTimerExceeded), userInfo: nil, repeats: false)
    }

    // If the timer reaches the limit as defined in timeoutInSeconds, post this notification.
    @objc func idleTimerExceeded() {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: TimerUIApplication.ApplicationDidTimoutNotification), object: nil)
    }

    override func sendEvent(_ event: UIEvent) {
        super.sendEvent(event)

        if idleTimer != nil {
            resetIdleTimer()
        }

        if let touches = event.allTouches {
            for touch in touches {
                if touch.phase == UITouch.Phase.began {
                    resetIdleTimer()
                }
            }
        }
    }
}
