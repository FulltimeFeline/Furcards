//
//  LoopingVideoView.swift
//  Furcards
//

import SwiftUI
import AVKit

/// Silent looping video with no controls, used as an animated logo (onboarding
/// header + settings). Loads from an asset-catalog data set. Uses the ambient
/// audio session so it doesn't interrupt the user's music. Renders nothing if
/// the asset is missing.
struct LoopingVideoView: UIViewRepresentable {
    /// Name of the asset-catalog data set (an .mp4 inside Assets.xcassets).
    let resource: String

    func makeUIView(context: Context) -> LoopingPlayerView {
        LoopingPlayerView(assetName: resource)
    }

    func updateUIView(_ uiView: LoopingPlayerView, context: Context) {}
}

/// UIView that owns an `AVQueuePlayer` + `AVPlayerLooper` for gap-free looping.
final class LoopingPlayerView: UIView {
    private let queuePlayer = AVQueuePlayer()
    private var looper: AVPlayerLooper?
    private let playerLayer = AVPlayerLayer()

    init(assetName: String) {
        super.init(frame: .zero)
        backgroundColor = .clear
        isUserInteractionEnabled = false

        // ambient session so it mixes with the user's music instead of pausing it
        try? AVAudioSession.sharedInstance().setCategory(.ambient, mode: .default, options: [.mixWithOthers])

        guard let url = Self.localURL(forAsset: assetName) else { return }
        let item = AVPlayerItem(url: url)
        looper = AVPlayerLooper(player: queuePlayer, templateItem: item)
        queuePlayer.isMuted = true
        queuePlayer.allowsExternalPlayback = false
        playerLayer.player = queuePlayer
        playerLayer.videoGravity = .resizeAspect
        layer.addSublayer(playerLayer)
        queuePlayer.play()

        // playback pauses when the app backgrounds, so resume on return
        NotificationCenter.default.addObserver(
            self, selector: #selector(resume),
            name: UIApplication.didBecomeActiveNotification, object: nil
        )
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    /// AVPlayer can't read straight from a data set, so write it to a temp file
    /// once and reuse it.
    private static func localURL(forAsset name: String) -> URL? {
        guard let asset = NSDataAsset(name: name) else { return nil }
        let url = FileManager.default.temporaryDirectory.appendingPathComponent("\(name).mp4")
        if !FileManager.default.fileExists(atPath: url.path) {
            do { try asset.data.write(to: url) } catch { return nil }
        }
        return url
    }

    @objc private func resume() { queuePlayer.play() }

    override func layoutSubviews() {
        super.layoutSubviews()
        playerLayer.frame = bounds
    }
}
