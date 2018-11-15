//
//  AppValues.swift
//  InsperationTomato
//
//  Created by Lyn Almasri on 11/14/18.
//  Copyright © 2018 lynmasri. All rights reserved.
//

import Foundation

// MARK: Changable values
class AppValues{
    static var shortBreak : Float!
    static var longBreak : Float!
    static var workSession : Float!
    public static func toSeconds(timer : Float) -> Float{
        return timer*60.0
    }

}
