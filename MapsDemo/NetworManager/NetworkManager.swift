//
//  NetworkManager.swift
//  EngineeringAiTask
//
//  Created by Sri Hari on 06/03/20.
//  Copyright © 2020 Ojas. All rights reserved.
//

import Foundation

protocol NetworkDelegate {
    func respondsToNetworkChages(isActive:Bool)
}

class NetworkManager {
    
    let reachability = try? Reachability()
    var networkDelegate:NetworkDelegate?
    //Check for active connection
    func hasActiveConnection() -> Bool {
        do {
            try? reachability?.startNotifier()
        }
        let status = reachability?.connection
        switch status {
        case .cellular:
            return true
        case .wifi:
            return true
        case .unavailable:
            return false
        case .none:
            return false
        case .some(.none):
            return false
        }
    }
    // Responds to network changes
    func checkNetworkfluctuations() {
        reachability?.whenReachable = { reachability in
            self.networkDelegate?.respondsToNetworkChages(isActive: true)
        }
        reachability?.whenUnreachable = { reachability in
        self.networkDelegate?.respondsToNetworkChages(isActive: false)
        }
    }
}
