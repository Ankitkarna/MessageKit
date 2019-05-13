//
//  VideoMessageCell.swift
//  InputBarAccessoryView
//
//  Created by Ankit Karna on 5/13/19.
//

import UIKit

/// A subclass of `MessageContentCell` used to display video and audio messages.
open class VideoMessageCell: MessageContentCell {

    /// The play button view to display on video messages.
    open lazy var playButton: PlayButtonView = {
        let playButton = PlayButtonView()
        return playButton
    }()

    /// The image view display the media content.
    open var videoView: VideoPlayerView = {
        let videoView = VideoPlayerView()
        return videoView
    }()

    // MARK: - Methods

    /// Responsible for setting up the constraints of the cell's subviews.
    open func setupConstraints() {
        videoView.fillSuperview()
        videoView.delegate = self
        playButton.centerInSuperview()
        playButton.constraint(equalTo: CGSize(width: 35, height: 35))
    }

    open override func setupSubviews() {
        super.setupSubviews()
        messageContentContainerView.addSubview(videoView)
        messageContentContainerView.addSubview(playButton)
        setupConstraints()
    }

    open override func prepareForReuse() {
        super.prepareForReuse()

    }

    /// Handle tap gesture on contentView and its subviews.
    open override func handleTapGesture(_ gesture: UIGestureRecognizer) {
        let touchLocation = gesture.location(in: self)
        let messageContentPoint = self.convert(touchLocation, to: messageContentContainerView)
        if messageContentContainerView.frame.contains(messageContentPoint) {
            if videoView.state == .playing {
                playButton.isHidden = false
                videoView.pauseVideo()
            } else {
                playButton.isHidden = true
                videoView.playVideo()
            }
        } else {
            super.handleTapGesture(gesture)
        }
    }

    open override func configure(with message: MessageType, at indexPath: IndexPath, and messagesCollectionView: MessagesCollectionView) {
        super.configure(with: message, at: indexPath, and: messagesCollectionView)

        switch message.kind {
        case .video(let mediaItem):
            guard let mediaUrl = mediaItem.url else { return }
            videoView.setupPlayer(url: mediaUrl, thumbnailImage: mediaItem.placeholderImage)
        default:
            break
        }
    }
}

extension VideoMessageCell: VideoViewDelegate {
    func videoDidChangeState(_ state: VideoState) {
        switch state {
        case .playing: self.playButton.isHidden = true
        default: self.playButton.isHidden = false
        }
    }
}
