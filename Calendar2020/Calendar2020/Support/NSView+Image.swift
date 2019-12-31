//
//  NSView+Image.swift
//  Calendar2020
//
//  Created by iOSDevLog on 2019/12/31.
//  Copyright © 2019 iOSDevLog. All rights reserved.
//

import Cocoa

extension NSView {
    /// Get `NSImage` representation of the view.
    ///
    /// - Returns: `NSImage` of view

    func image() -> NSImage {
        let imageRepresentation = bitmapImageRepForCachingDisplay(in: bounds)!
        cacheDisplay(in: bounds, to: imageRepresentation)
        return NSImage(cgImage: imageRepresentation.cgImage!, size: bounds.size)
    }

    /// Get `Data` representation of the view.
    ///
    /// - Parameters:
    ///   - fileType: The format of file. Defaults to PNG.
    ///   - properties: A dictionary that contains key-value pairs specifying image properties.
    /// - Returns: `Data` for image.

    func data(using fileType: NSBitmapImageRep.FileType = .png, properties: [NSBitmapImageRep.PropertyKey: Any] = [:]) -> Data {
        let imageRepresentation = bitmapImageRepForCachingDisplay(in: bounds)!
        cacheDisplay(in: bounds, to: imageRepresentation)
        return imageRepresentation.representation(using: fileType, properties: properties)!
    }

    func setBackgroundColor(backgroundColor: NSColor) {
        layer?.backgroundColor = backgroundColor.cgColor
    }
}
