//
//  CalWindow.swift
//  Calendar2020
//
//  Created by iOSDevLog on 2019/12/30.
//  Copyright © 2019 iOSDevLog. All rights reserved.
//

import Cocoa

class CalWindow: NSWindow {
    override init(contentRect: NSRect, styleMask style: NSWindow.StyleMask, backing backingStoreType: NSWindow.BackingStoreType, defer flag: Bool) {
        super.init(contentRect: contentRect, styleMask: style, backing: backingStoreType, defer: flag)

        level = NSWindow.Level(rawValue: NSWindow.Level.RawValue(CGWindowLevelForKey(CGWindowLevelKey.desktopWindow) - 1))

        collectionBehavior = NSWindow.CollectionBehavior(rawValue: NSWindow.CollectionBehavior.RawValue(UInt8(NSWindow.CollectionBehavior.canJoinAllSpaces.rawValue) |
                UInt8(NSWindow.CollectionBehavior.stationary.rawValue) |
                UInt8(NSWindow.CollectionBehavior.ignoresCycle.rawValue)))

        backgroundColor = NSColor(named: "Background")
        isOpaque = false
    }

    override var canBecomeMain: Bool {
        return false
    }

    override var canBecomeKey: Bool {
        return false
    }
}
