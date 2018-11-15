//
//  Constants.swift
//  InsperationTomato
//
//  Created by Lyn Almasri on 11/14/18.
//  Copyright © 2018 lynmasri. All rights reserved.
//

import Foundation
import UIKit
import SystemConfiguration

class Constants{
    static let ApiScheme = "http"
    static let ApiHost = "quotes.rest"
    static let ApiPath = "/qod.json"
}

struct ColorPalette{
    public static let spaceGray = UIColor(red: 39/255.0, green: 39/255.0, blue: 39/255.0, alpha: 1)
    public static let green = UIColor(red: 161/255.0, green: 243/255.0, blue: 82/255.0, alpha: 1)
    public static let orange = UIColor(red: 200/255.0, green: 62/255.0, blue: 40/255.0, alpha: 1)
    public static let ivory = UIColor(red: 247/255.0, green: 242/255.0, blue: 184/255.0, alpha: 1)
    public static let brown = UIColor(red: 82/255.0, green: 30/255.0, blue: 36/255.0, alpha: 1)
    public static let lightGray = UIColor(red: 193/255.0, green: 193/255.0, blue: 193/255.0, alpha: 1)
}

func connectedToNetwork() -> Bool {
    
    var zeroAddress = sockaddr_in()
    zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
    zeroAddress.sin_family = sa_family_t(AF_INET)
    
    guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
        $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
            SCNetworkReachabilityCreateWithAddress(nil, $0)
        }
    }) else {
        return false
    }
    
    var flags: SCNetworkReachabilityFlags = []
    if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
        return false
    }
    
    let isReachable = flags.contains(.reachable)
    let needsConnection = flags.contains(.connectionRequired)
    
    return (isReachable && !needsConnection)
}

