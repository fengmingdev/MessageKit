//
//  File.swift
//  
//
//  Created by fengming on 2022/2/9.
//

import UIKit

/// A subclass of `MessageContentCell` used to display video and audio messages.
open class WalletMessageCell: MessageContentCell {

    lazy var titleLabel: InsetLabel = {
        let label = InsetLabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor(red: 0.96, green: 0.88, blue: 0.56,alpha:1)
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
    
    // 遮罩
    open var imageMaskView: UIView = {
        let maskView = UIView()
        return maskView
    }()
    
    // MARK: - Methods

    /// Responsible for setting up the constraints of the cell's subviews.
    open func setupConstraints(_ mediaItem: WalletItem) {
        let width = mediaItem.size.width
        let height = mediaItem.size.height
        
        imageView.frame = CGRect(x: 0, y: 0, width: width, height: height)
        
        imageMaskView.frame = CGRect(x: 0, y: 0, width: width, height: height)
        imageMaskView.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.5)

        titleLabel.frame = CGRect(x: 8, y: 0, width: width - 16, height: 60)
        titleLabel.center = CGPoint(x: width/2, y: height/2 - 35)
        titleLabel.textAlignment = .center
        
        operateButtonView.frame = CGRect(x: 0, y: 0, width: 45, height: 45)
        operateButtonView.center = CGPoint(x: width/2, y: height/2 + 45)
    }

    open override func setupSubviews() {
        super.setupSubviews()
        messageContainerView.addSubview(imageView)
        messageContainerView.addSubview(titleLabel)
        messageContainerView.addSubview(operateButtonView)
        messageContainerView.addSubview(imageMaskView)
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
        case .wallet(let mediaItem):
            imageView.image = mediaItem.image ?? mediaItem.placeholderImage
            operateButtonView.setImage(mediaItem.operateImage ?? mediaItem.placeholderImage, for: .normal)
            titleLabel.text = mediaItem.title
            titleLabel.textColor = UIColor(red: 0.96, green: 0.88, blue: 0.56,alpha:1)
            imageMaskView.isHidden = !mediaItem.isMaskShow
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
