//
//  File.swift
//
//
//  Created by fengming on 2022/2/9.
//

import Foundation
import UIKit

/// A protocol used to represent the data for a media message.
public protocol GiftItem {

    var title: String? { get }
    
    var description: String? { get }
    
    /// The url where the media is located.
    var url: URL? { get }
    
    /// The image.
    var image: UIImage? { get }

    /// A placeholder image for when the image is obtained asychronously.
    var placeholderImage: UIImage { get }
    
    /// A operate image for when the image is obtained asychronously.
    var backgroundImage: UIImage? { get }
    
    /// The size of the media item.
    var size: CGSize { get }
}

