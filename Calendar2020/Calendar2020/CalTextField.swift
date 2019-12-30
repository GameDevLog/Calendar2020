//
//  CalTextField.swift
//  Calendar2020
//
//  Created by iOSDevLog on 2019/12/30.
//  Copyright © 2019 iOSDevLog. All rights reserved.
//

import Cocoa

@IBDesignable
class CalTextField: NSTextField {
    @IBInspectable
    var href: String = ""

    override func awakeFromNib() {
        super.awakeFromNib()

        let attributes: [NSAttributedString.Key: AnyObject] = [
            NSAttributedString.Key.foregroundColor: NSColor.systemBlue,
            NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue as AnyObject
        ]
        attributedStringValue = NSAttributedString(string: stringValue, attributes: attributes)
    }
    
    override func mouseDown(with event: NSEvent) {
        NSWorkspace.shared.open(URL(string: href)!)
    }
}
