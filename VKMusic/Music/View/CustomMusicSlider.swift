//
//  CustomMusicSlider.swift
//  VKMusic
//
//  Created by Robert on 11.11.2018.
//  Copyright © 2018 Robert. All rights reserved.
//

import UIKit.UIView


class CustomMusicSlider: UISlider {
    
    @IBInspectable var thumbNormalImage: UIImage? {
        didSet {
            setThumbImage(#imageLiteral(resourceName: "thumbSlider"), for: .normal)
        }
    }
    
    @IBInspectable var thumbHighlightedImage: UIImage? {
        didSet {
            setThumbImage(#imageLiteral(resourceName: "thumbSlider"), for: .highlighted)
        }
    }
    
}
