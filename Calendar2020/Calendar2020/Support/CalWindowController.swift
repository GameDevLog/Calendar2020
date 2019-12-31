//
//  CalWindowController.swift
//  Calendar2020
//
//  Created by iOSDevLog on 2019/12/30.
//  Copyright © 2019 iOSDevLog. All rights reserved.
//

import Cocoa
import Quartz

class CalWindowController: NSWindowController {
    override func windowDidLoad() {
        super.windowDidLoad()

        if let window = window, let screen = window.screen {
            let offsetFromLeftOfScreen: CGFloat = 0
            let offsetFromTopOfScreen: CGFloat = 0

            let screenRect = screen.visibleFrame
            let newOriginY = screenRect.maxY - window.frame.height - offsetFromTopOfScreen

            window.setFrameOrigin(NSPoint(x: offsetFromLeftOfScreen, y: newOriginY))
            window.setFrame(screenRect, display: true)
        }
    }
}
