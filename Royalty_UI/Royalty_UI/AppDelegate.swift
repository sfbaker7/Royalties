//
//  AppDelegate.swift
//  Royalty_UI
//
//  Created by Stuart Baker on 12/23/16.
//  Copyright © 2016 Stuart Baker. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    @IBOutlet weak var window: NSWindow!
    var blurryView = NSVisualEffectView(frame: NSRect(x: 0, y: 0, width: 800, height: 600))
    

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        
        blurryView.wantsLayer = true
        blurryView.blendingMode = NSVisualEffectBlendingMode.withinWindow
        blurryView.material = NSVisualEffectMaterial.dark
        blurryView.state = NSVisualEffectState.active

//        self.window.contentView?.addSubview(blurryView)
        
        
        
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

