//
//  VideoPlayer.swift
//  InputBarAccessoryView
//
//  Created by Ankit Karna on 5/13/19.
//

import Foundation
import AVFoundation


public class VideoPlayer: NSObject {
    let avPlayer: AVPlayer

    init(url: URL) {
        self.avPlayer = AVPlayer(url: url)
        super.init()

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(playerItemDidPlayToCompletion(_:)),
                                               name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
                                               object: avPlayer.currentItem)
    }

    @objc
    public func pause() {
        avPlayer.pause()
    }

    @objc
    public func play() {

        guard let item = avPlayer.currentItem else {
            print("video player item was unexpectedly nil")
            return
        }

        if item.currentTime() == item.duration {
            // Rewind for repeated plays, but only if it previously played to end.
            avPlayer.seek(to: .zero)
        }

        avPlayer.play()
    }

    @objc
    public func stop() {
        avPlayer.pause()
        avPlayer.seek(to: .zero)
    }

    @objc(seekToTime:)
    public func seek(to time: CMTime) {
        avPlayer.seek(to: time)
    }

    // MARK: private

    @objc
    private func playerItemDidPlayToCompletion(_ notification: Notification) {
        print("completed")
    }
}
