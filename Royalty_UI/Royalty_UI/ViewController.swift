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
    @IBOutlet weak var test_text1: NSTextField!
    var profile = Format_profile()
    


    //Hadles uploadind and processing the csv file
    @IBAction func handle_upload(_ sender: Any) {

        
        //open file
        let file_picker: NSOpenPanel = NSOpenPanel()
        file_picker.allowsMultipleSelection = false
        file_picker.canChooseFiles = true
        file_picker.canChooseDirectories = false
        file_picker.runModal()
        var fileURL = file_picker.url!
        print(fileURL.absoluteString)
        
        var temp_array : [String] = []
        
        //read file
        do {
            let file_contents = try String(contentsOf: fileURL, encoding: String.Encoding.utf8)
            let file_rows = file_contents.components(separatedBy: "\n") as [String]
            temp_array = file_rows
        }
        catch {print("Error")}
        
        //performs data manipulation on csv profile
        self.profile.performProcess(contents: temp_array)

    }
    
    @IBAction func handle_download(_ sender: Any) {

        //Opens the save Panel
        let savePanel = NSSavePanel()
        savePanel.begin { (result: Int) -> Void in
            if result == NSFileHandlingPanelOKButton {
                let exportedFileURL = savePanel.url
                //writes to selected path
                do {
                    try self.profile.final_text.write(to: exportedFileURL!, atomically: false, encoding: String.Encoding.utf8)
                }
                catch {/* error handling here */}
            }
        }
        
 
        
        
    }
    
    //selects format
    @IBAction func handle_format(_ sender: Any) {
        self.profile.setFormat(form: format_selector.titleOfSelectedItem!)
        welcome_msg.stringValue =  self.profile.toString()
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

