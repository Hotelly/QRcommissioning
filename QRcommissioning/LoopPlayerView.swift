//
//  LoopPlayerView.swift
//  QRcommissioning
//
//  Created by sid on 06/05/24.
//

import SwiftUI

import SwiftUI
import AVKit

struct LoopPlayerView: View {
    private let player: AVQueuePlayer
    private let playerLooper: AVPlayerLooper

    init(videoName: String, videoExtension: String) {
        guard let fileUrl = Bundle.main.url(forResource: videoName, withExtension: videoExtension) else {
            fatalError("Failed to locate video file \(videoName).\(videoExtension) in bundle.")
        }
        let asset = AVAsset(url: fileUrl)
        let item = AVPlayerItem(asset: asset)
        self.player = AVQueuePlayer(playerItem: item)
        self.playerLooper = AVPlayerLooper(player: player, templateItem: item)
        self.player.play()
    }

    var body: some View {
        VideoPlayer(player: player)
            .onDisappear {
                player.pause()
            }
            .aspectRatio(contentMode: .fill)
            .ignoresSafeArea()
    }
}


#Preview {
    LoopPlayerView(videoName: "v", videoExtension: "m4v")
}
