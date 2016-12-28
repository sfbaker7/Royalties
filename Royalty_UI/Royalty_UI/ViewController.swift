//
//  ViewController.swift
//  Royalty_UI
//
//  Created by Stuart Baker on 12/23/16.
//  Copyright © 2016 Stuart Baker. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    @IBOutlet weak var welcome_msg: NSTextField!
    @IBOutlet weak var format_selector: NSPopUpButton!
    @IBOutlet weak var upload_button: NSButton!
    
    
    @IBAction func handle_upload(_ sender: Any) {
    }
    
    @IBAction func handle_format(_ sender: Any) {
        let format_instance = format_profile(format_id: format_selector.titleOfSelectedItem!)
        welcome_msg.stringValue =  format_instance.toString()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

