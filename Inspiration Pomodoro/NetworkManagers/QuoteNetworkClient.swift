//
//  QuoteNetworkClient.swift
//  Insperation Pomodoro
//
//  Created by Lyn Almasri on 11/14/18.
//  Copyright © 2018 lynmasri. All rights reserved.
//

import Foundation
import UIKit

class QuoteNetworkClient{
    var dataController:DataController!
    var appDelegate : AppDelegate!
    public func getQuoteOfTheDay(completionHandler: @escaping (_ quote: Quote?, _ error: String?) -> Void){
        appDelegate = UIApplication.shared.delegate as? AppDelegate
        dataController = appDelegate.dataController
        let client = NetworkClient()
        let parameters = [
            "category" : "inspire"] as [String:AnyObject]
        client.getMethod(url: "", parameters: parameters) { (data, error) in
            guard (error == nil) else{
                completionHandler(nil,error?.domain)
                return
            }
            do{
                let parsedObject = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String:AnyObject]
                guard let success = parsedObject["success"] else{
                    print("1")
                    completionHandler(nil,"There was a problem with retrieving the Quote")
                    return
                }
                let total = success["total"] as! Bool
                guard (total == true) else{
                    print("2")
                    completionHandler(nil,"There was a problem with retrieving the Quote")
                    return
                }
                guard let contents = parsedObject["contents"] as? [String:AnyObject] else{
                    print("3")
                    completionHandler(nil,"There was a problem with retrieving the Quote")
                    return
                }
                guard let quotes = contents["quotes"] as? [[String:AnyObject]] else{
                    print("4")
                    completionHandler(nil,"There was a problem with retrieving the Quote")
                    return
                }
                guard (quotes.count != 0) else{
                    print("5")
                    completionHandler(nil,"There was a problem with retrieving the Quote")
                    return
                }
                
                let quoteObject = Quote(context: self.dataController.viewContext)
                quoteObject.author = quotes[0]["author"] as? String
                quoteObject.id = quotes[0]["id"] as? String
                quoteObject.quoteBody = quotes[0]["quote"] as? String
                quoteObject.date = Date()
                completionHandler(quoteObject,nil)
                
                
                
            } catch{
                completionHandler(nil,"There was a problem with retrieving the Quote")
                return
            }
            
        }
    }
}
