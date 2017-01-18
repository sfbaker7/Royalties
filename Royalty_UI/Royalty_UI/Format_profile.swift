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
    var input_data : [String] = []
    var output_data : [String] = []
    var output_text : String = ""
    var count : Int = 0
    
    
    //Data is processed through case dependent format models, which match the user's selected format
    func performProcess() throws {
        switch format {
        case "BMI":
            let temp_data = BMI_model()
            do{
                try temp_data.process_data(contents: self.input_data)
            }
            catch {
                throw ProcessError.wrongFormat
            }
            self.output_data = temp_data.findata
            self.count = temp_data.count
            processString()

            
        case "SATV":
            let temp_data = SATV_Model()
            temp_data.process_data(contents: self.input_data)
            self.output_data = temp_data.findata
            self.count = temp_data.count
            processString()
//            throw ProcessError.noFormat
            
        case "ASCAP":
            let temp_data = ASCAP_Model()
            temp_data.process_data(contents: self.input_data)
            self.output_data = temp_data.findata
            self.count = temp_data.count
            processString()
            
        default:
            throw ProcessError.wrongFormat
        }

        
    }
    //Sets the input data as a [String]
    func setInput(contents : [String]){
        self.input_data = contents
    }
    
    //Converts the processed data from [String] to String
    func processString(){
        for i in 0...self.count-1{
            self.output_text.append(self.output_data[i])
        }
    }
  
    //Sets the user selected format
    func setFormat(form : String){
        self.format = form
    }
    
    
}
