//
//  RepeatingTimer.swift
//  CurrencyRates
//
//  Created by Shantanu Khanwalkar on 22/03/18.
//  Copyright © 2018 Shantanu Khanwalkar. All rights reserved.
//

import Foundation

// Daniel Galasko - https://gist.githubusercontent.com/danielgalasko/1da90276f23ea24cb3467c33d2c05768/raw/1e4da4767a54156fc959434dc6807644f94f0cbe/RepeatingTimer.swift

/// Using this class to call an event after a regular interval
class RepeatingTimer {
    
    private lazy var timer: DispatchSourceTimer = {
        let t = DispatchSource.makeTimerSource()
        t.schedule(deadline: .now() + 3, repeating: .seconds(10))
        t.setEventHandler(handler: { [weak self] in
            self?.eventHandler?()
        })
        return t
    }()
    
    /// The event that needs to be called
    var eventHandler: (() -> Void)?
    
    /// The state of the timer stored as an enum
    private enum State {
        case suspended
        case resumed
    }
    
    /// Initially setting the state of the timer as suspended
    private var state: State = .suspended
    
    /// Deinitializing the timer
    deinit {
        timer.setEventHandler {}
        timer.cancel()
        /*
         If the timer is suspended, calling cancel without resuming
         triggers a crash. This is documented here https://forums.developer.apple.com/thread/15902
         */
        resume()
        eventHandler = nil
    }
    
    /// Resumes the tiemr
    func resume() {
        if state == .resumed {
            return
        }
        state = .resumed
        timer.resume()
    }
    
    /// Suspends the timer
    func suspend() {
        if state == .suspended {
            return
        }
        state = .suspended
        timer.suspend()
    }
}
