//
//  NetworkMonitor.swift
//  RappiCodeChallenge
//
//  Created by Vincent Villalta on 11/8/21.
//

import Network

class NetworkMonitor {
    let monitor = NWPathMonitor()
    var connected = true
    var isCelullar = false
    let queue = DispatchQueue(label: "NetworkMonitor")
    static let shared = NetworkMonitor()
    
    func startMonitoring() {
        monitor.start(queue: queue)
        monitor.pathUpdateHandler = { path in
            self.connected = path.status == .satisfied
            self.isCelullar = path.isExpensive
        }
    }
}
