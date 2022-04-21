//
//  File.swift
//
//
//  Created by fengming on 2022/2/9.
//

import UIKit

/// A subclass of `MessageContentCell` used to display video and audio messages.
open class GiftMessageCell: MessageContentCell {

    lazy var titleLabelL: InsetLabel = {
        let label = InsetLabel()
        label.numberOfLines = 0
        label.textAlignment = .right
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor(red: 0.96, green: 0.88, blue: 0.56,alpha:1)
        return label
    }()
    
    lazy var descriptionLabelL: InsetLabel = {
        let label = InsetLabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 9)
        label.textColor = UIColor(red: 0.96, green: 0.88, blue: 0.56,alpha:1)
        label.textAlignment = .right
        return label
    }()
    
    lazy var titleLabelR: InsetLabel = {
        let label = InsetLabel()
        label.numberOfLines = 0
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor(red: 0.96, green: 0.88, blue: 0.56,alpha:1)
        return label
    }()
    
    lazy var descriptionLabelR: InsetLabel = {
        let label = InsetLabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 9)
        label.textColor = UIColor(red: 0.96, green: 0.88, blue: 0.56,alpha:1)
        label.textAlignment = .left
        return label
    }()
    
    /// The image view display the media content.
    open var backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    // 操作
    open var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    // MARK: - Methods

    /// Responsible for setting up the constraints of the cell's subviews.
    open func setupConstraints() {
        
        backgroundImageView.addConstraints(centerY: self.centerYAnchor,
                                 centerX: self.centerXAnchor,
                                 centerYConstant: 0,
                                 centerXConstant: 0,
                                 widthConstant: 100,
                                 heightConstant: 94)
        
        imageView.addConstraints(centerY: backgroundImageView.centerYAnchor,
                                 centerX: backgroundImageView.centerXAnchor,
                                 centerYConstant: 0,
                                 centerXConstant: 0,
                                 widthConstant: 75,
                                 heightConstant: 75)

        titleLabelL.addConstraints(bottom: imageView.centerYAnchor,
                                   right: backgroundImageView.leftAnchor,
                                   bottomConstant: 8,
                                   rightConstant: 8,
                                   widthConstant: 80)
        
        titleLabelR.addConstraints(left: backgroundImageView.rightAnchor,
                                   bottom: imageView.centerYAnchor,
                                   leftConstant: 8,
                                   bottomConstant: 8,
                                   widthConstant: 80)
        
        descriptionLabelL.addConstraints(imageView.centerYAnchor,
                                         right: titleLabelL.rightAnchor,
                                         topConstant: 0,
                                         rightConstant: 0,
                                         widthConstant: 80)
        
        descriptionLabelR.addConstraints(imageView.centerYAnchor,
                                         left: titleLabelR.leftAnchor,
                                         topConstant: 0,
                                         leftConstant: 0,
                                         widthConstant: 80)
    }

    open override func setupSubviews() {
        super.setupSubviews()
        messageContainerView.addSubview(backgroundImageView)
        messageContainerView.addSubview(titleLabelL)
        messageContainerView.addSubview(descriptionLabelL)
        messageContainerView.addSubview(titleLabelR)
        messageContainerView.addSubview(descriptionLabelR)
        messageContainerView.addSubview(imageView)
        setupConstraints()
    }
    
    open override func prepareForReuse() {
        super.prepareForReuse()
        self.backgroundImageView.image = nil
        self.imageView.image = nil
    }

    open override func configure(with message: MessageType, at indexPath: IndexPath, and messagesCollectionView: MessagesCollectionView) {
        super.configure(with: message, at: indexPath, and: messagesCollectionView)

        guard let displayDelegate = messagesCollectionView.messagesDisplayDelegate else {
            fatalError(MessageKitError.nilMessagesDisplayDelegate)
        }
        guard let dataSource = messagesCollectionView.messagesDataSource else {
            fatalError(MessageKitError.nilMessagesDataSource)
        }

        if dataSource.isFromCurrentSender(message: message) { // outgoing message
            titleLabelL.isHidden = true
            descriptionLabelL.isHidden = true
            
            titleLabelR.isHidden = false
            descriptionLabelR.isHidden = false
        } else { // incoming message
            titleLabelR.isHidden = true
            descriptionLabelR.isHidden = true
            
            titleLabelL.isHidden = false
            descriptionLabelL.isHidden = false
        }
        self.layoutIfNeeded()
        switch message.kind {
        case .gift(let mediaItem):
            backgroundImageView.image = mediaItem.backgroundImage
            imageView.image = mediaItem.image ?? mediaItem.placeholderImage
            titleLabelL.text = mediaItem.title
            titleLabelL.textColor = .white
            
            descriptionLabelL.textColor = .white
            descriptionLabelL.text = mediaItem.description
            
            titleLabelR.text = mediaItem.title
            titleLabelR.textColor = .white
            
            descriptionLabelR.textColor = .white
            descriptionLabelR.text = mediaItem.description
            
        default:
            break
        }
        displayDelegate.configureMediaMessageImageView(imageView, for: message, at: indexPath, in: messagesCollectionView)
    }
    
    /// Handle tap gesture on contentView and its subviews.
    open override func handleTapGesture(_ gesture: UIGestureRecognizer) {
        let touchLocation = gesture.location(in: backgroundImageView)

        guard backgroundImageView.frame.contains(touchLocation) else {
            super.handleTapGesture(gesture)
            return
        }
        delegate?.didTapImage(in: self)
    }
    
}
