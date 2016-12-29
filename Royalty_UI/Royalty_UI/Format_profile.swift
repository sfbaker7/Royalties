//
//  format_profile.swift
//  Royalty_UI
//
//  Created by Stuart Baker on 12/28/16.
//  Copyright © 2016 Stuart Baker. All rights reserved.
//

import Foundation


class Format_profile : NSObject{
    
    var format: String
    
    init(format_id: String){
        self.format = format_id
        
    }
    
    func toString()->String{
        return self.format
    }
    
}
