//
//  ViewController.swift
//  LunarCalendar
//
//  Created by Dat Nguyen on 12/31/16.
//  Copyright © 2016 Dat Nguyen. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    @IBOutlet var MyView: NSView!
    @IBOutlet weak var Solar: NSButton!
    @IBOutlet weak var Solar_Year: NSTextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


    @IBAction func Push(_ sender: NSButton) {
        _ = alert(message: "Hello", caption: "Hi")
        //solarYear.stringValue = String(floor(2.435))
    }
    
    func alert(message: String, caption: String) -> Bool {
        let myPopup: NSAlert = NSAlert()
        myPopup.messageText = message
        myPopup.informativeText = caption
        myPopup.alertStyle = NSAlertStyle.warning
        myPopup.addButton(withTitle: "OK")
        let result = myPopup.runModal()
        return (result == NSAlertFirstButtonReturn)
    }
}

