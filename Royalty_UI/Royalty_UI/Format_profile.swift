//
//  format_profile.swift
//  Royalty_UI
//
//  Created by Stuart Baker on 12/28/16.
//  Copyright © 2016 Stuart Baker. All rights reserved.
//

import Foundation


class Format_profile : NSObject{
    
    var format: String = ""
    var final_text : String = ""
    
    func performProcess(contents: [String]){
        
        switch format {
        case "Lefrak":
            let final_data = Lefrak_model()
            final_data.process_data(contents: contents)
            processString(arr: final_data)
        default:
            print("failed")
        }

        
    }
    
    func processString(arr: Lefrak_model){
        for i in 0...arr.count-1{
            self.final_text.append(arr.stringAtIndex(int: i))
        }
    }
  
    func setFormat(form : String){
        self.format = form
    }
    
    func toString()->String{
        return self.format
    }
    
}
