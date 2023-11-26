//
//  WCSessionManager.swift
//  HeartGuardian
//
//  Created by Ezagor on 26.11.2023.
//

import Foundation
import WatchConnectivity

class WCSessionManager: NSObject, WCSessionDelegate {
    static let shared = WCSessionManager()
    var heartRateObservable = HeartRateObservable()

    override init() {
        super.init()
        if WCSession.isSupported() {
            let session = WCSession.default
            session.delegate = self
            session.activate()
        }
    }

    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        // Handle session activation
    }

    func sessionDidBecomeInactive(_ session: WCSession) {
        // Handle session becoming inactive
    }

    func sessionDidDeactivate(_ session: WCSession) {
        // Handle session deactivation
        // On iOS, you may need to reactivate the session here
        WCSession.default.activate()
    }

    func session(_ session: WCSession, didReceiveMessage message: [String: Any]) {
        if let heartRate = message["heartRate"] as? Double {
            DispatchQueue.main.async {
                self.heartRateObservable.heartRate = heartRate
            }
        }
    }

}

