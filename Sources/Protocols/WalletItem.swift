//
//  File.swift
//  
//
//  Created by fengming on 2022/2/9.
//

import Foundation
import UIKit

/// A protocol used to represent the data for a media message.
public protocol WalletItem {

    var title: String? { get }
    
    /// The image.
    var image: UIImage? { get }

    /// A placeholder image for when the image is obtained asychronously.
    var placeholderImage: UIImage { get }
    
    /// A operate image for when the image is obtained asychronously.
    var operateImage: UIImage? { get }

    // 是否添加遮罩
    var isMaskShow: Bool { get }
    
    /// The size of the media item.
    var size: CGSize { get }

}
