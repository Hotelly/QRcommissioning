//
//  QRcommissioningApp.swift
//  QRcommissioning
//
//  Created by sid on 31/01/24.
//

import SwiftUI

@main
struct QRcommissioningApp: App {
    @Environment(\.scenePhase) var scenePhase
    let networkState = NetworkMonitoring()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(networkState)
//                .onChange(of: scenePhase){ newScenePhase in
//                    if newScenePhase == .background {
//                        exit(0)
//                    }
//                }
                .onChange(of: scenePhase, { oldValue, newValue in
                    if newValue == .background {
                        exit(0)
                    }
                })

//                .background(
//                    Image("TvOSAppBackground")
//                        .resizable()
//                        .scaledToFill()
//                        .blur(radius: 40, opaque: false)
//                        .overlay(content: {
//                            Color.black.opacity(0.25)
//                        })

//                ).ignoresSafeArea()
        }
    }
}
