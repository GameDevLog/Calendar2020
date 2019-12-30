//
//  CalViewController.swift
//  Calendar2020
//
//  Created by iOSDevLog on 2019/12/30.
//  Copyright © 2019 iOSDevLog. All rights reserved.
//

import Cocoa

class CalViewController: NSViewController {
    @IBOutlet var calImageView: CalImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

        calImageView.image = NSImage(named: "2020")
    }

    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }
}
