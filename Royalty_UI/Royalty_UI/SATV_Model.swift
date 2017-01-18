//
//  SATV_Model.swift
//  Royalty_UI
//
//  Created by Stuart Baker on 1/9/17.
//  Copyright © 2017 Stuart Baker. All rights reserved.
//

import Foundation


class SATV_Model : NSObject {
    
    var findata: Array<String> = []
    var count : Int = 0
//    var territory : String = ""
    var type : String = ""
    var amount : Double = 0.0
    
    
    var north_america : Set = ["SAMP Canada","SAMP United States","SAMP Mexico"]
    var europe : Set = ["SAMP Europe", "SAMP Germany","SAMP Holland", "SAMP Scandinavia", "SAMP UK", "SAMP Poland", "SAMP Italy", "SAMP Greece", "SAMP France", "SAMP Spain","SAMP Russia"]
    var se_asia : Set = ["SAMP Hong Kong", "SAMP Japan", "SAMP Malaysia", "SAMP China", "SAMP Singapore", "SAMP Taiwan", "SAMP India", "SAMP Korea"]
    var australia : Set = ["SAMP Australia"]
    var south_africa : Set = ["SAMP South Africa"]
    var south_america : Set = ["SAMP Brazil", "SAMP Latin", "SAMP Argentina", "SAMP Chile", "SAMP Colombia"]
    
    var mechanical : Set = ["Mechanical", "DPD- Mechanical", "Stream – Mechanical", "Mechanical Performance", "DPD – Mechanical", "Ringtone Download", "Society Karaoke Mechanical"]
    var performance : Set = ["Performance", "Stream – Performance", "Television Performance", "General Performance", "Radio", "Live Performance", "Film Performance", "Society Karaoke Performance"]
    var sync : Set = ["Synch General", "Synch TV", "Other", "Synch Online", "Synch Video"]
    var print_type : Set = ["Print", "Lyric Reprint (online)"]
    
    

    
    
    
    //Main data proccessor function - sums up royalty sales per song
    func process_data(contents: [String]){
        let royalties_dict : [String:Double] = createDict(arr: contents)
        var final_list : [String] = []
        for (title, amount) in royalties_dict{
            count += 1
            let temp : String = title + "," + String(amount) + "\n"
            final_list.append(temp)
        }
        self.findata = quicksort(final_list)
    }
    
    //creates dictionary of song titles and royalty amounts
    func createDict(arr : [String])->Dictionary<String, Double>{
        var song_dict : [String : String] = ["TITLE NAME" : "Territory"]
        var territory_dict : [String: Set] = ["Territory" : ["Income Type"]]
        var type_dict : [String : Double] = ["Income Type" : 0.0]
        print(arr)
        for index in 6...arr.count-1{
            var row : [String] = arr[index].components(separatedBy: ",")
            print(row[row.count-1])
            let amount : Double = Double(row[row.count-1])!
            if song_dict[row[2]] == nil{
                song_dict[row[2]] = getTerritory(row: row)
                territory_dict[getTerritory(row: row)]?.insert(getIncomeType(row: row))
                type_dict[getIncomeType(row: row)] = amount
                
                
            }
            else{
                if territory_dict[getTerritory(row: row)]==nil{
                    territory_dict[getTerritory(row: row)]?.insert(getIncomeType(row: row))
                    type_dict[getIncomeType(row: row)] = amount
                    
                }
                else{
                    if type_dict[getIncomeType(row: row)] == nil{
                        type_dict[getIncomeType(row: row)] = amount
                    }
                    else{
                        type_dict[getIncomeType(row: row)]! += amount
                    }
                }
            }
            print(song_dict.description)
            song_dict.removeAll()
            territory_dict.removeAll()
            type_dict.removeAll()
            
        }
        return type_dict
    }
    
    
    
    //gets the territory of the song
    func getTerritory(row : [String])->String{
        let tstring : String = row[row.count-14]
        
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
        else{
            return "Unkown Territory"
        }
        
        
        
        return tstring
    }
    
    func getIncomeType(row : [String])->String{
        let type : String = row[row.count-11]
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
