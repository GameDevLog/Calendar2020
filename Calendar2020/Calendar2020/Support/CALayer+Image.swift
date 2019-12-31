//
//  CALayer+Image.swift
//  Calendar2020
//
//  Created by iOSDevLog on 2019/12/31.
//  Copyright © 2019 iOSDevLog. All rights reserved.
//

import Cocoa

extension CALayer {
    /// Get `NSImage` representation of the layer.
    ///
    /// - Returns: `NSImage` of the layer.
    func image() -> NSImage {
        let width = Int(bounds.width * contentsScale)
        let height = Int(bounds.height * contentsScale)
        let imageRepresentation = NSBitmapImageRep(bitmapDataPlanes: nil, pixelsWide: width, pixelsHigh: height, bitsPerSample: 8, samplesPerPixel: 4, hasAlpha: true, isPlanar: false, colorSpaceName: NSColorSpaceName.deviceRGB, bytesPerRow: 0, bitsPerPixel: 0)!
        imageRepresentation.size = bounds.size

        let context = NSGraphicsContext(bitmapImageRep: imageRepresentation)!

        render(in: context.cgContext)

        return NSImage(cgImage: imageRepresentation.cgImage!, size: bounds.size)
    }

    /// Get `Data` representation of the layer.
    ///
    /// - Parameters:
    ///   - fileType: The format of file. Defaults to PNG.
    ///   - properties: A dictionary that contains key-value pairs specifying image properties.
    ///
    /// - Returns: `Data` for image.
    func data(using fileType: NSBitmapImageRep.FileType = .png, properties: [NSBitmapImageRep.PropertyKey: Any] = [:]) -> Data {
        let width = Int(bounds.width * contentsScale)
        let height = Int(bounds.height * contentsScale)
        let imageRepresentation = NSBitmapImageRep(bitmapDataPlanes: nil, pixelsWide: width, pixelsHigh: height, bitsPerSample: 8, samplesPerPixel: 4, hasAlpha: true, isPlanar: false, colorSpaceName: NSColorSpaceName.deviceRGB, bytesPerRow: 0, bitsPerPixel: 0)!
        imageRepresentation.size = bounds.size

        let context = NSGraphicsContext(bitmapImageRep: imageRepresentation)!

        render(in: context.cgContext)

        return imageRepresentation.representation(using: fileType, properties: properties)!
    }
}
