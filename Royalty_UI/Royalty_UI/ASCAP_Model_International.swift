//
//  ASCAP_Model.swift
//  Royalty_UI
//
//  Created by Stuart Baker on 1/16/17.
//  Copyright © 2017 Stuart Baker. All rights reserved.
//

import Foundation


class ASCAP_Model_International : NSObject {
    
    var findata: Array<String> = []
    var count : Int = 0
    //    var territory : String = ""
    var type : String = ""
    var amount : Double = 0.0
    
    
    var north_america : Set = ["CANADA", "MEXICO", "BERMUDA", "BARBADOS", "TRINIDAD & TOBAGO"]
    var europe : Set = ["RUSSIA", "POLAND", "UNITED KINGDOM", "IRELAND", "FRANCE", "GERMANY", "ITALY", "SPAIN", "ROMANIA", "SWITZERLAND", "CZECH REPUBLIC", "SLOVAKIA", "LITHUANIA", "SWEDEN", "NORWAY", "DENMARK", "FINLAND", "BELGIUM", "HOLLAND", "NETHERLANDS", "LUXEMBOURG", "GREECE", "LATVIA", "HUNGARY" , "PORTUGAL"]
    var se_asia : Set = ["JAPAN", "SOUTH KOREA", "CHINA", "TAIWAN", "MALAYSIA", "SINGAPORE", "INDIA", "VIET NAM", "PHILIPPINES"]
    var australia : Set = ["AUSTRALIA","NEW ZEALAND"]
    var south_africa : Set = ["SOUTH AFRICA"]
    var south_america : Set = ["BRAZIL", "COLOMBIA", "VENEZUELA", "PERU", "ARGENTINA", "CHILE", "ECUADOR", "BOLIVIA" , "LATIN AMERICA"]
    

    
    
    //Main data proccessor function - sums up royalty sales per song per territory
    func process_data(contents: [String]){
        let royalties_dict : [String:String] = parseCSV(file_rows: contents)
        var final_list : [String] = []
        for (title,listing) in royalties_dict{
            count += 1
            let temp : String = title + "," + listing  + "\n"
            final_list.append(temp)
        }
        self.findata = quicksort(final_list)
    }
    
    //creates dictionary of song titles and royalty amounts. Uses nested dictionary and returns a dictionary with the nested dictionary in String format
    func parseCSV(file_rows : [String])->Dictionary<String, String>{
        
        var song_dict : [String : [String : Double]] = [".TITLE NAME" : [".TERRITORY" : 0.0]]
        var fin_dict : [String : String] = [".TITLE NAME" : ".TERRITORY, AMOUNT"]
        
        let delimiter = ","
        var items:[(name:String, territory:String, price: String)]
        var master_items : [(name:String, territory:String, price: String)]
        
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
                
                
                let terr : String = getTerritory(ostring: values[8])
                let amount : Double = Double(values[23])!

                let item = ((name:values[13], territory: terr, price: amount))

                
                if song_dict[item.name] == nil{
                    var terr_dict : [String : Double] = [:]
                    terr_dict[item.territory] = amount
                    song_dict[item.name] = terr_dict
                }
                else{
                    var temp_dict : [String : Double] = song_dict[item.name]!
                    if (temp_dict[item.territory]==nil){
                        temp_dict[item.territory] = amount
                    }
                    else{
                        temp_dict[item.territory]! += amount
                    }
                    song_dict[item.name] = temp_dict
                }
                var temp_string : String = ""
                
                //Turns the nested dictionary into a string in the specified format
                for (place, price) in song_dict[item.name]!{
                    temp_string = temp_string + place + ": " + ", " +  String(price) + "\n" + ","
                }
                
                fin_dict[item.name] = temp_string
                
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
