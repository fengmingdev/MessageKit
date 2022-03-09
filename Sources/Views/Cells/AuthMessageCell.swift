//
//  File.swift
//  
//
//  Created by fengming on 2022/3/9.
//

import Foundation
import UIKit

/// A subclass of `MessageContentCell` used to display video and audio messages.
open class AuthMessageCell: MessageContentCell {

    lazy var titleLabel: InsetLabel = {
        let label = InsetLabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .white
        return label
    }()
    
    lazy var descriptionLabel: InsetLabel = {
        let label = InsetLabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = UIColor(red: 0.73, green: 0.31, blue: 0.96,alpha:1)
        label.textAlignment = .center
        return label
    }()
    
    /// The image view display the media content.
    open var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    // MARK: - Methods

    /// Responsible for setting up the constraints of the cell's subviews.
    open func setupConstraints() {
        imageView.fillSuperview()
        
        titleLabel.addConstraints(messageContainerView.topAnchor, left: messageContainerView.leftAnchor, right: messageContainerView.rightAnchor, topConstant: 20, leftConstant: 5, rightConstant: 5)
        
        descriptionLabel.addConstraints(left: messageContainerView.leftAnchor, bottom: messageContainerView.bottomAnchor, right: messageContainerView.rightAnchor, leftConstant: 5, rightConstant: 5)
    }

    open override func setupSubviews() {
        super.setupSubviews()
        messageContainerView.addSubview(imageView)
        messageContainerView.addSubview(titleLabel)
        messageContainerView.addSubview(descriptionLabel)
        setupConstraints()
    }
    
    open override func prepareForReuse() {
        super.prepareForReuse()
        self.imageView.image = nil
    }

    open override func configure(with message: MessageType, at indexPath: IndexPath, and messagesCollectionView: MessagesCollectionView) {
        super.configure(with: message, at: indexPath, and: messagesCollectionView)

        guard let displayDelegate = messagesCollectionView.messagesDisplayDelegate else {
            fatalError(MessageKitError.nilMessagesDisplayDelegate)
        }

        switch message.kind {
        case .auth(let authItem):
            imageView.image = authItem.image
            if let title = authItem.title {
                titleLabel.text = title
            }
            if let description = authItem.description {
                descriptionLabel.text = description
                descriptionLabel.isHidden = false
            } else {
                descriptionLabel.isHidden = true
            }
        default:
            break
        }

        displayDelegate.configureMediaMessageImageView(imageView, for: message, at: indexPath, in: messagesCollectionView)
    }
    
    /// Handle tap gesture on contentView and its subviews.
    open override func handleTapGesture(_ gesture: UIGestureRecognizer) {
        let touchLocation = gesture.location(in: imageView)

        guard imageView.frame.contains(touchLocation) else {
            super.handleTapGesture(gesture)
            return
        }
        delegate?.didTapImage(in: self)
        
    }
    
}
