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

    
    
    //Main data proccessor function - sums up royalty sales per song
    func process_data(contents: [String]) throws {
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
            let temp : String = title + "," + String(amount) + "\n"
            final_list.append(temp)
            
        }
        
        self.findata = quicksort(final_list)
        
    }
    
    //creates dictionary of song titles and royalty amounts
    func createDict(arr : [String]) throws ->Dictionary<String, Double> {
        
        var dict : [String:Double] = ["TITLE NAME" : 0.0]
        for index in 1...arr.count-1{
            var row : [String] = arr[index].components(separatedBy: ",")
            
            let amount : Double = Double(row[row.count-10])!
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
