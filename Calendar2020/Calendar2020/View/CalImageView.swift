//
//  CalImageView.swift
//  Calendar2020
//
//  Created by iOSDevLog on 2019/12/30.
//  Copyright © 2019 iOSDevLog. All rights reserved.
//

import Cocoa

class CalImageView: NSImageView {
    override var image: NSImage? {
        set {
            layer = CALayer()
            layer?.contentsGravity = CALayerContentsGravity.resizeAspectFill
            layer?.contents = newValue
            wantsLayer = true

            super.image = newValue
        }

        get {
            return super.image
        }
    }
}
