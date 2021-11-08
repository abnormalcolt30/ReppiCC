//
//  RappiCodeChallengeApp.swift
//  RappiCodeChallenge
//
//  Created by Vincent Villalta on 11/8/21.
//

import SwiftUI

@main
struct RappiCodeChallengeApp: App {
    @Environment(\.scenePhase) private var scenePhase
    var body: some Scene {
        WindowGroup {
            StartView(viewModel: StartViewModel())
        }.onChange(of: scenePhase) { newValue in
            switch newValue {
            case .background, .inactive:
                break
            case .active:
                NetworkMonitor.shared.startMonitoring()
            @unknown default:
                break
            }
        }
    }
    
}
