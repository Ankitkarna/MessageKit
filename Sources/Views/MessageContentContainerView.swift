//
//  MessageContentContainerView.swift
//  InputBarAccessoryView
//
//  Created by Ankit Karna on 5/13/19.
//

import UIKit

open class MessageContentContainerView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }

    private func setupUI() {
        //self.backgroundColor = .clear
    }
}
