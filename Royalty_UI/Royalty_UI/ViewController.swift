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
    @IBOutlet weak var download_button: NSButton!
    @IBOutlet weak var upload_button: NSButton!
    
    
//    var fileURL:URL
    
 

    
    @IBAction func handle_upload(_ sender: Any) {
        
        //open file
        let file_picker: NSOpenPanel = NSOpenPanel()
        file_picker.allowsMultipleSelection = false
        file_picker.canChooseFiles = true
        file_picker.canChooseDirectories = false
        file_picker.runModal()
        var fileURL = file_picker.url!
      
        //read file
        do {
            let file_content = try String(contentsOf: fileURL, encoding: String.Encoding.utf8)
            print(file_content)
        }
        catch {print("Error")}
        
    }
    
    @IBAction func handle_download(_ sender: Any) {
        
    }
    
    @IBAction func handle_format(_ sender: Any) {
        let format_instance = Format_profile(format_id: format_selector.titleOfSelectedItem!)
        
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

