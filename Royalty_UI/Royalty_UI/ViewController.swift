//
//  ViewController.swift
//  Royalty_UI
//
//  Created by Stuart Baker on 12/23/16.
//  Copyright © 2016 Stuart Baker. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    

    @IBOutlet weak var communicator: NSTextField!
    @IBOutlet weak var welcome_msg: NSTextField!
    @IBOutlet weak var format_selector: NSPopUpButton!
    @IBOutlet weak var download_button: NSButton!
    @IBOutlet weak var upload_button: NSButton!
    @IBOutlet weak var progress_bar: NSProgressIndicator!
    var profile = Format_profile()

   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //format selector setup
        format_selector.addItems(withTitles: ["ASCAP Domestic", "ASCAP International", "BMG", "BMI"])
        format_selector.isTransparent = false
        
        progress_bar.isDisplayedWhenStopped = false
        

        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear() {

    }
    
    
    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }
    
    //Hadles uploadind and processing the csv file
    @IBAction func handle_upload(_ sender: Any) {
   
        //open file
        let file_picker: NSOpenPanel = NSOpenPanel()
        file_picker.allowsMultipleSelection = false
        file_picker.canChooseFiles = true
        file_picker.canChooseDirectories = false
        file_picker.runModal()
        
        guard let fileURL = file_picker.url else{
            file_picker.close()
            return
        }
        
        print(fileURL.absoluteString)
        
        var temp_array : [String] = []
        
        //read file
        do {
            let file_contents = try String(contentsOf: fileURL, encoding: String.Encoding.utf8)
//            let file_rows = file_contents.components(separatedBy: NSCharacterSet.newlines) as [String]
            let file_rows = file_contents.components(separatedBy: "\n")
            temp_array = file_rows
            print ("Text seperated by newline: " + String(file_rows.count))
        }
        catch {
            
            file_picker.close()
            
        }
            
        
        
        //sets the input data for the format profile
        self.profile.setInput(contents: temp_array)
        
    }
    
    @IBAction func handle_download(_ sender: Any) {
        //main data manipulation process
        progress_bar.startAnimation(Any?.self)
        do{
            try self.profile.performProcess()
        }
        catch ProcessError.noFormat{
            self.communicator.stringValue = "Error: No Format Selected"
            return
        }
        catch ProcessError.wrongFormat {
            self.communicator.stringValue = "Error: No Format Selected"
            return
        }
        catch {
            self.communicator.stringValue = "Error: This File is Not Compatible for this Program"
            return
        }
        progress_bar.stopAnimation(Any?.self)
        
        
        //Opens the save Panel
        let savePanel = NSSavePanel()
        savePanel.begin { (result: Int) -> Void in
            if result == NSFileHandlingPanelOKButton {
                let exportedFileURL = savePanel.url
                //writes to selected path
                do {
                    try self.profile.output_text.write(to: exportedFileURL!, atomically: false, encoding: String.Encoding.utf8)
                }
                catch {
                    savePanel.close()
                    return
                }
            }
            
        }

    }
    
    //selects format
    @IBAction func handle_format(_ sender: Any) {
        self.profile.setFormat(form: format_selector.titleOfSelectedItem!)
        self.format_selector.setTitle(format_selector.titleOfSelectedItem!)
    }
    

    



    



}

