//
//  File.swift
//  
//
//  Created by fengming on 2022/2/9.
//

import UIKit

/// A subclass of `MessageContentCell` used to display video and audio messages.
open class GiftMessageCell: MessageContentCell {

    lazy var titleLabel: InsetLabel = {
        let label = InsetLabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor(red: 0.96, green: 0.88, blue: 0.56,alpha:1)
        return label
    }()
    
    lazy var descriptionLabel: InsetLabel = {
        let label = InsetLabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 9)
        label.textColor = UIColor(red: 0.96, green: 0.88, blue: 0.56,alpha:1)
        label.textAlignment = .center
        return label
    }()
    
    /// The image view display the media content.
    open var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    // 操作
    open lazy var operateButtonView: UIButton = {
        let button = UIButton()
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16)
        return button
    }()
    
 
    // MARK: - Methods

    /// Responsible for setting up the constraints of the cell's subviews.
    open func setupConstraints(_ mediaItem: GiftItem) {
        let width = mediaItem.size.width
        let height = mediaItem.size.height
        
        imageView.frame = CGRect(x: 0, y: 0, width: 100, height: 94)
        imageView.center = CGPoint(x: width/2, y: height/2)
        
        operateButtonView.frame = CGRect(x: 0, y: 0, width: 39, height: 69)
        operateButtonView.center = CGPoint(x: width/2, y: height/2)
        
        titleLabel.frame = CGRect(x: 0, y: 0, width: 100, height: 30)
        
        descriptionLabel.frame = CGRect(x: 0, y: 0, width: 100, height: 30)
        
        titleLabel.center = CGPoint(x: width/2 + 110, y: height/2 - 28)
        titleLabel.textAlignment = .left
        
        descriptionLabel.center = CGPoint(x: width/2 + 110, y: height/2)
        descriptionLabel.textAlignment = .left
    }

    open override func setupSubviews() {
        super.setupSubviews()
        messageContainerView.addSubview(imageView)
        messageContainerView.addSubview(titleLabel)
        messageContainerView.addSubview(descriptionLabel)
        messageContainerView.addSubview(operateButtonView)
        
    }
    
    open override func prepareForReuse() {
        super.prepareForReuse()
        self.imageView.image = nil
        self.operateButtonView.imageView?.image = nil
    }

    open override func configure(with message: MessageType, at indexPath: IndexPath, and messagesCollectionView: MessagesCollectionView) {
        super.configure(with: message, at: indexPath, and: messagesCollectionView)

        guard let displayDelegate = messagesCollectionView.messagesDisplayDelegate else {
            fatalError(MessageKitError.nilMessagesDisplayDelegate)
        }

        switch message.kind {
        case .gift(let mediaItem):
            imageView.image = mediaItem.image
            operateButtonView.setImage(mediaItem.operateImage ?? mediaItem.placeholderImage, for: .normal)
            titleLabel.text = mediaItem.title
            titleLabel.textColor = .white
            
            descriptionLabel.textColor = .white
            descriptionLabel.text = mediaItem.description
            
            setupConstraints(mediaItem)
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
