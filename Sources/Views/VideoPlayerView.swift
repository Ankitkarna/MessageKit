//
//  PostVideoView.swift
//  PetBook
//
//  Created by Ankit Karna on 3/7/19.
//  Copyright © 2019 EBPearls. All rights reserved.
//

import UIKit
import AVFoundation

protocol VideoViewDelegate: AnyObject {
    func videoDidChangeState(_ state: VideoState)
}

enum VideoState {
    case playing
    case paused
    case stopped
}

open class VideoPlayerView: UIView {

    override open class var layerClass: AnyClass {
        return AVPlayerLayer.self
    }

    private var playerLayer: AVPlayerLayer {
        return layer as! AVPlayerLayer //swiftlint:disable:this force_cast
    }

    private var player: AVPlayer? {
        didSet { playerLayer.player = player }
    }

    private lazy var placeholderImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    private(set) var state: VideoState = .stopped

    weak var delegate: VideoViewDelegate?

    private var isPlayerReadyToDisplayObserver: NSKeyValueObservation?
    private var isPlayerReadyToPlayObserver: NSKeyValueObservation?

    lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.hidesWhenStopped = true
        indicator.color = UIColor.blue
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }

    private func setupUI() {
        playerLayer.videoGravity = .resizeAspectFill

        self.addSubview(activityIndicator)
        activityIndicator.centerInSuperview()

        self.insertSubview(placeholderImageView, belowSubview: activityIndicator)
        placeholderImageView.fillSuperview()

        self.backgroundColor = .lightGray
        activityIndicator.startAnimating()

        isPlayerReadyToDisplayObserver = playerLayer.observe(\.isReadyForDisplay, options: [.new, .old]) { [unowned self] (valueLayer, _) in
            if valueLayer.isReadyForDisplay {
                self.activityIndicator.stopAnimating()
                self.removePlaceholderView()
            } else {
                self.activityIndicator.startAnimating()
                self.addPlaceholderView()
            }
        }

        NotificationCenter.default.addObserver(self, selector: #selector(stopVideo), name: .AVPlayerItemDidPlayToEndTime, object: nil)
    }

    @objc private func playVideoTapped() {
        playVideo()
    }

    func playVideo() {
        state = .playing
        delegate?.videoDidChangeState(state)
        playerLayer.player?.play()
    }

    private func addPlaceholderView() {
        if !placeholderImageView.isDescendant(of: self) {
            self.insertSubview(placeholderImageView, belowSubview: activityIndicator)
            placeholderImageView.fillSuperview()
        }
    }

    private func removePlaceholderView() {
        if placeholderImageView.isDescendant(of: self) {
            placeholderImageView.removeFromSuperview()
        }
    }

    @objc private func stopVideo() {
        player?.seek(to: .zero)
        player?.pause()
        state = .stopped
        delegate?.videoDidChangeState(state)
    }

    func pauseVideo() {
        player?.pause()
        state = .paused
        delegate?.videoDidChangeState(state)
    }

    deinit {
        isPlayerReadyToDisplayObserver = nil
        isPlayerReadyToPlayObserver = nil

        player?.replaceCurrentItem(with: nil)
        player = nil

        //print("deinit-> \(String(describing: self))")

        NotificationCenter.default.removeObserver(self)
    }

    func setupPlayer(url: URL, thumbnailImage: UIImage?) {
        player = AVPlayer(url: url)
        placeholderImageView.image = thumbnailImage
    }

    func setupPlayer(item: AVPlayerItem) {
        //if there is already item associated with player, it doesnot allow reallocating same item with another player,so we make new one while to associate for different player
        let newItem = AVPlayerItem(asset: item.asset)
        player = AVPlayer(playerItem: newItem)
    }

}
