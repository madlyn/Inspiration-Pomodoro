//
//  SettingsViewController.swift
//  Insperation Pomodoro
//
//  Created by Lyn Almasri on 11/14/18.
//  Copyright © 2018 lynmasri. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var workSessionTextField: UITextField!
    @IBOutlet weak var longBreakTextField: UITextField!
    @IBOutlet weak var shortBreakTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = ColorPalette.spaceGray
        
    }
    
    
    @IBAction func donePressed(_ sender: Any) {
        if let work = workSessionTextField.text{
            let workTime = Float(work)
            if workTime != nil{
                UserDefaults.standard.set(workTime, forKey: "WorkSession")
            }
        }
        if let longBreak = longBreakTextField.text{
            let longBreakTime = Float(longBreak)
            if longBreakTime != nil{
                UserDefaults.standard.set(longBreakTime, forKey: "LongBreak")
            }
        }
        if let shortBreak = shortBreakTextField.text{
            let shortBreakTime = Float(shortBreak)
            if shortBreakTime != nil{
                UserDefaults.standard.set(shortBreakTime, forKey: "ShortBreak")
            }
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
