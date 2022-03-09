//
//  File.swift
//  
//
//  Created by fengming on 2022/3/9.
//

import Foundation
import UIKit

/// A protocol used to represent the data for a media message.
public protocol AuthItem {

    var title: String? { get }
    
    var description: String? { get }
    
    /// The image.
    var image: UIImage? { get }
    
    /// The size of the media item.
    var size: CGSize { get }
}
