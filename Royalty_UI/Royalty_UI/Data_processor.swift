//
//  File.swift
//  Royalty_UI
//
//  Created by Stuart Baker on 12/28/16.
//  Copyright © 2016 Stuart Baker. All rights reserved.
//

import Foundation

class Data_processor: NSObject{
    
    var fileURL: URL
    var format: String
    
    init(furl: URL, format_id: String){
        self.fileURL = furl
        format = format_id
        
        
    }
    func setFormat(format_id: String){
        self.format = format_id
    }
    func getURL()->URL{
        return fileURL
    }
    
    func readData(){
        
        
    }
    
}
