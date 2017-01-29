//
//  BMG_Model.swift
//  Royalty_UI
//
//  Created by Stuart Baker on 1/19/17.
//  Copyright © 2017 Stuart Baker. All rights reserved.
//

import Foundation




class BMG_Model : NSObject {
    
    var findata: Array<String> = []
    var count : Int = 0
    var type : String = ""
    var amount : Double = 0.0
    var master_count : Int = 0
    let delimiter = ","

    
    
    var north_america : Set = ["BHS", "BMU", "CAN", "MEX", "USA"]
    var europe : Set = ["NLD", "UNS","AUT", "BEL", "BGR", "CHE", "CYP", "CZE", "DEU", "DNK", "ESP", "EST", "FIN", "FRA", "GBR", "GRC", "HUN", "IRL", "ISL", "ISR", "ITA", "LTU", "LUX", "LVA", "MCO", "MLT", "NOR", "POL", "PRT", "ROU", "RUS", "SVK", "SVN", "SWE", "TUR", "HRV", "SRB"]
    var se_asia : Set = ["JPN", "MYS", "KOR"]
    var australia : Set = ["AUS"]
    var south_africa : Set = ["ZFA", "SEN"]
    var south_america : Set = ["ARG", "BRA", "CHL"]
    
    var mechanical : Set = [1, 2, 11, 13, 14, 22, 35, 36, 37, 39, 40, 41, 42]
    var performance : Set = [4, 9, 12, 15, 16, 17, 18, 19, 20, 34, 38, 43, 45, 46]
    var sync : Set = [5, 8, 10, 21, 23, 24, 25, 28, 29, 30, 44, 47, 48, 49]
    var print_type : Set = [3, 6, 7, 26, 27]
    
    
    
    
    
    //Main data proccessor function - sums up royalty sales per song per territory
    func process_data(contents: [String]){
        let royalties_dict : [String:String] = parseCSV(file_rows: contents)
        var final_list : [String] = []
        for (title,listing) in royalties_dict{
            count += 1
            var tempstring : String = title
            if (title.contains(",")){
                var temparray : [String] = title.components(separatedBy: ",")
                tempstring = temparray.joined(separator: "~")
            }
            let temp : String = tempstring + "," + listing  + "\n"
            final_list.append(temp)
        }
        self.findata = quicksort(final_list)
    }
    
    
    //Parses the CSV file and compiles royalty amounts per song per territory per income type
    func parseCSV(file_rows : [String]) -> [String : String] {
        var song_dict : [String : [String : [String : Double]]] = ["TITLE NAME" : ["TERRITORY" : ["INCOME TYPE" : 0.0]]]
        var fin_dict : [String : String] = ["TITLE NAME" : "TERRITORY, INCOME TYPE, AMOUNT"]
        
        var items:[(name:String, territory:String, income_type: String, price: String)]
        
        items = []
        var break_count : Int = 0
        for row in file_rows{

            if (break_count == 0){
                break_count += 1
                continue
            }
            var values:[String] = []
            if row != "" {
                if row.range(of: "\"") != nil {

                    var textToScan:String = row
                    var value:NSString?
                    var textScanner:Scanner = Scanner(string: textToScan)
                    while textScanner.string != "" {
                        
                        if (textScanner.string as NSString).substring(to: 1) == "\"" {
                            textScanner.scanLocation += 1
                            textScanner.scanUpTo("\"", into: &value)
                            textScanner.scanLocation += 1
                        }
                        else {
                            textScanner.scanUpTo(delimiter, into: &value)
                        }
                        values.append(value as! String)
                        
                        // Retrieve the unscanned remainder of the string
                        if textScanner.scanLocation < textScanner.string.characters.count {
                            textToScan = (textScanner.string as NSString).substring(from: textScanner.scanLocation + 1)

                        } else {
                            textToScan = ""
                        }
                        textScanner = Scanner(string: textToScan)
                    }
                    
                }
                else  {
                    values = row.components(separatedBy: delimiter)

                }
                // Put the values into the tuple and add it to the items array
                let terr : String = getTerritory(ostring: values[21])
                let inc_type : String = getIncomeType(ostring: values[7])
                let item = ((name:values[3], territory: terr, income_type: inc_type, price: values[14]))
                let amount : Double = Double(item.price)!
                
                
                if song_dict[item.name] == nil{
                    var inc_dict : [String : Double] = [:]
                    var terr_dict : [String : [String : Double]] = [:]
                    inc_dict[item.income_type] = amount
                    terr_dict[item.territory] = inc_dict
                    song_dict[item.name] = terr_dict
                }
                else{
                    var temp_dict : [String : [String : Double]] = song_dict[item.name]!
                    if (temp_dict[item.territory]==nil){
                        temp_dict[item.territory] = [item.income_type : amount]
                    }
                    else{
                        var temp_dict2 : [String : Double] = temp_dict[item.territory]!
                        if (temp_dict2[item.income_type] == nil){
                            temp_dict2[item.income_type] = amount
                        }
                        else{
                            temp_dict2[item.income_type]! += amount
                        }
                        temp_dict[item.territory] = temp_dict2
                        
                    }
                    song_dict[item.name] = temp_dict
                }
                var temp_string : String = ""
                
                
                //Turns the nested dictionary into a string in the specified format
                for (place, inc_dict) in song_dict[item.name]!{
                    
                    for (inc_type, price) in inc_dict{
                        
                        temp_string = temp_string + ", " + place + ", " + inc_type + ", " + String(price) + "\n" + ","
                    }
                }
                
                
                fin_dict[item.name] = temp_string
                items.append(item)
                
            }
            
            
        }
        
        return fin_dict
    }

    
    
    
    //gets the territory of the song
    func getTerritory(ostring : String)->String{
       
        let tstring : String = ostring.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)

        if north_america.contains(tstring){
            return "North America"
        }
        if europe.contains(tstring){
            return "Europe"
        }
        if south_africa.contains(tstring){
            return "South Africa"
        }
        if se_asia.contains(tstring){
            return "S.E. Asia"
        }
        if australia.contains(tstring){
            return "Australia"
        }
        if south_america.contains(tstring){
            return "South America"
        }
            
        else{
            return "Unkown Territory"
        }
        
    }
    
    //gets the income type of the song
    func getIncomeType(ostring : String)->String{
        
        let type : Int = Int(ostring)!

        if mechanical.contains(type){
            return "Mechanical"
        }
        if performance.contains(type){
            return "Performance"
        }
        if sync.contains(type){
            return "Synch"
        }
        if print_type.contains(type){
            return "Print"
        }
        else{
            return "unkown print"
        }
    }
    
    func findElement_IT(instance_count : Int)->Int{
        let difference : Int = instance_count-master_count
        
        
        return 0
        
    }
    
    func findElement_Terr()->Int{
        
        return 0
        
    }
    
    
    //Quicksort Algorithm
    func quicksort<T: Comparable>(_ a: [T]) -> [T]{
        guard a.count > 1 else { return a as! [T] }
        
        let pivot = a[a.count/2]
        let less = a.filter { $0 < pivot }
        let equal = a.filter { $0 == pivot }
        let greater = a.filter { $0 > pivot }
        
        return quicksort(less) + equal + quicksort(greater)
    }
    
    
    
    
    
    
}
