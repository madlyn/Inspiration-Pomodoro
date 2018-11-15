//
//  NetworkClient.swift
//  Insperation Pomodoro
//
//  Created by Lyn Almasri on 11/14/18.
//  Copyright © 2018 lynmasri. All rights reserved.
//

import Foundation

class NetworkClient{
    var session = URLSession.shared
    func getMethod(url : String, parameters : [String:AnyObject], completionHandler :@escaping (_ result: Data?, _ error: NSError?) -> Void){
        if  connectedToNetwork() == false{
            let userInfo = [NSLocalizedDescriptionKey : "No Internet connection"]
            completionHandler(nil, NSError(domain: "No Internet connection", code: 1, userInfo: userInfo))
        }
        let request = URLRequest(url: uRLFromParameters(parameters))
        let task = session.dataTask(with: request) { (data, response, error) in
            func sendError(_ error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandler(nil, NSError(domain: "getMethod", code: 1, userInfo: userInfo))
            }
            guard (error == nil) else {
                sendError("There was an error with your request: \(error!)")
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!")
                return
            }
            
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            completionHandler(data,nil)
        }
        task.resume()
    }
    
    private func uRLFromParameters(_ parameters: [String:AnyObject], withPathExtension: String? = nil) -> URL {
        
        var components = URLComponents()
        components.scheme = Constants.ApiScheme
        components.host = Constants.ApiHost
        components.path = Constants.ApiPath + (withPathExtension ?? "")
        components.queryItems = [URLQueryItem]()
        
        for (key, value) in parameters {
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            components.queryItems!.append(queryItem)
        }
        print(components.url)
        return components.url!
    }
    
}
