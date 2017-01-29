//
//  Sony_model.swift
//  Royalty_UI
//
//  Created by Stuart Baker on 12/29/16.
//  Copyright © 2016 Stuart Baker. All rights reserved.
//
//
import Foundation

class BMI_model: NSObject{
    
    var findata: Array<String> = []
    var count : Int = 0
    let delimiter = ","


    
    
    //Main data proccessor function - sums up royalty sales per song
    func process_data(contents: [String]) throws {
        print(contents)
        var royalties_dict : [String : Double]
        do{
        royalties_dict = try createDict(arr: contents)
        }
        catch{
            throw ProcessError.wrongFormat
            return
        }
        
        var final_list : [String] = []
        for (title, amount) in royalties_dict{
            count += 1
            var tempstring : String = title
            if (title.contains(",")){
                let temparray : [String] = title.components(separatedBy: ",")
                tempstring = temparray.joined(separator: "~")
            }

            let temp : String = tempstring + "," + String(amount) + "\n"
            final_list.append(temp)
            
        }
        
        self.findata = quicksort(final_list)
        
    }
    
    //creates dictionary of song titles and royalty amounts
    func createDict(arr : [String]) throws ->Dictionary<String, Double> {
        print (arr.count)
        var dict : [String:Double] = ["TITLE NAME" : 0.0]
        for index in 1...arr.count-2{
            var row : [String] = arr[index].components(separatedBy: ",")
            print(row)
            print(row.count)
            print(row[17])
            
            
            let amount : Double = Double(row[17])!
            if dict[row[5]] == nil{
                dict[row[5]] = amount
            }
            else{
                dict[row[5]]! += amount
            }
        }
        return dict
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
