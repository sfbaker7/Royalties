//
//  ASCAP_Model_Domestic.swift
//  Royalty_UI
//
//  Created by Stuart Baker on 1/18/17.
//  Copyright © 2017 Stuart Baker. All rights reserved.
//

import Foundation


class ASCAP_Model_Domestic: NSObject{
    
    var findata: Array<String> = []
    var count : Int = 0
    let delimiter = ","

    
    
    
    //Main data proccessor function - sums up royalty sales per song
    func process_data(contents: [String]) {
        var royalties_dict : [String : Double]
        
        royalties_dict = createDict(arr: contents)
//        royalties_dict = parseCSV(file_rows: contents)
        var final_list : [String] = []
        for (title, amount) in royalties_dict{
            count += 1
            var tempstring : String = title
            if (title.contains(",")){
                var temparray : [String] = title.components(separatedBy: ",")
                tempstring = temparray.joined(separator: "~")
            }

            let temp : String = tempstring + "," + String(amount) + "\n"
            final_list.append(temp)
            
        }
        
        self.findata = quicksort(final_list)
        
    }
    
    //creates dictionary of song titles and royalty amounts. Uses nested dictionary and returns a dictionary with the nested dictionary in String format
    func parseCSV(file_rows : [String])->Dictionary<String, Double>{
        
        var dict : [String:Double] = [".TITLE NAME" : 0.0]
        var items:[(name:String, price: String)]
        
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

                let amount : Double = Double(values[29])!
                print(amount)

                let item = ((name:values[5], price: amount))
                
                
                if dict[item.name] == nil{
                    dict[item.name] = item.price
                }
                else{
                    dict[item.name]! += item.price
                }
            }
            
        
        }
        return dict
    }

    
    //creates dictionary of song titles and royalty amounts
    func createDict(arr : [String]) -> Dictionary<String, Double> {
        
        var dict : [String:Double] = ["TITLE NAME" : 0.0]
        print(arr.count)
        print(arr[10])
        for index in 1...arr.count-2{
            print("arr index: " + arr[index])
            
            var row : [String] = arr[index].components(separatedBy: ",")
            print(row)
            print("Row count: " + String(row.count))
            print(row[29])
            let amount : Double = Double(row[29])!
            if dict[row[19]] == nil{
                dict[row[19]] = amount
            }
            else{
                dict[row[19]]! += amount
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
