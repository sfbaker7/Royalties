//
//  ASCAP_Model.swift
//  Royalty_UI
//
//  Created by Stuart Baker on 1/16/17.
//  Copyright © 2017 Stuart Baker. All rights reserved.
//

import Foundation


class ASCAP_Model : NSObject {
    
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
        let royalties_dict : [String:String] = createDict(arr: contents)
        var final_list : [String] = []
        for (title,listing) in royalties_dict{
            count += 1
            let temp : String = title + "," + listing  + "\n"
            final_list.append(temp)
        }
        self.findata = quicksort(final_list)
    }
    
    //creates dictionary of song titles and royalty amounts. Uses nested dictionary and returns a dictionary with the nested dictionary in String format
    func createDict(arr : [String])->Dictionary<String, String>{
        var song_dict : [String : [String : Double]] = ["TITLE NAME" : ["TERRITORY" : 0.0]]
        var fin_dict : [String : String] = ["TITLE NAME" : "TERRITORY, AMOUNT"]
        
        for index in 1...arr.count-2{
            var row : [String] = arr[index].components(separatedBy: ",")
            let name : String = row[13]
            let amount : Double = Double(row[23])!
            let territory : String = getTerritory(row: row)
            
            if song_dict[name] == nil{
                var terr_dict : [String : Double] = [:]
                terr_dict[territory] = amount
                song_dict[name] = terr_dict
            }
            else{
                var temp_dict : [String : Double] = song_dict[name]!
                if (temp_dict[territory]==nil){
                    temp_dict[territory] = amount
                }
                else{
                    temp_dict[territory]! += amount
                }
                song_dict[name] = temp_dict
            }
            var temp_string : String = ""
            
            //Turns the nested dictionary into a string in the specified format
            for (place, price) in song_dict[name]!{
                temp_string = temp_string + place + ": " + ", " +  String(price) + "\n" + ","
            }
            
            fin_dict[name] = temp_string
            
        }
        return fin_dict
    }
    
    
    
    //gets the territory of the song
    func getTerritory(row : [String])->String{
        let tstring : String = row[8]
        
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
        
        return tstring
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
