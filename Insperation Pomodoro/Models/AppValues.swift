//
//  AppValues.swift
//  InsperationTomato
//
//  Created by Lyn Almasri on 11/14/18.
//  Copyright © 2018 lynmasri. All rights reserved.
//

import Foundation
class AppValues{
    enum TimerValues : Float{
        case ShortBreak = 5
        case LongBreak = 15
        case WorkSession = 25
    }
    public static func toSeconds(timer : TimerValues) -> Float{
        return timer.rawValue*60.0
    }
}
