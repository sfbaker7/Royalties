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
        format_selector.addItems(withTitles: ["BMI","ASCAP", "SATV"])
        format_selector.isTransparent = false
        
        //progress bar setup
        self.progress_bar.isDisplayedWhenStopped = false
        self.progress_bar.isBezeled = true
        self.progress_bar.controlTint = NSControlTint.blueControlTint
        self.progress_bar.isIndeterminate = true
        

        
        
        
        
        
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
        
        guard var fileURL = file_picker.url else{
            file_picker.close()
            return
        }
        
        print(fileURL.absoluteString)
        
        var temp_array : [String] = []
        
        //read file
        do {
            let file_contents = try String(contentsOf: fileURL, encoding: String.Encoding.utf8)
            let file_rows = file_contents.components(separatedBy: "\n") as [String]
            temp_array = file_rows
//            print(file_rows)
//            print(file_rows.count)
        }
        catch {
            
            file_picker.close()
            
        }
            
        
        self.progress_bar.startAnimation(Any?)
        
        //sets the input data for the format profile
        self.profile.setInput(contents: temp_array)
        
        self.progress_bar.stopAnimation(Any?)
    }
    
    @IBAction func handle_download(_ sender: Any) {
        //main data manipulation process
        do{
            try self.profile.performProcess()
        }
        catch ProcessError.noFormat{
            self.communicator.stringValue = "Error: No Format Selected"
            return
        }
        catch ProcessError.wrongFormat {
            self.communicator.stringValue = "Error: Wrong Format"
            return
        }
        catch {
            self.communicator.stringValue = "Error: This File is Not Compatible for this Program"
            return
        }
        
        
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

