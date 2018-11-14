//
//  TimerViewController.swift
//  InsperationTomato
//
//  Created by Lyn Almasri on 11/13/18.
//  Copyright © 2018 lynmasri. All rights reserved.
//

import UIKit
import UICircularProgressRing
import AudioToolbox

class TimerViewController: UIViewController {

    @IBOutlet weak var progressBar: UICircularProgressRingView!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var typeSegment: UISegmentedControl!
    @IBOutlet weak var quoteButton: UIButton!
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var errorLabel: UILabel!
    
    var timeValue: Float = 0.0
    var maxTimeValue : Float = 0.0
    var timer : Timer!
    var timerRunning : Bool = false
    var quoteClient = QuoteNetworkClient()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
        startWiggling()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if typeSegment.selectedSegmentIndex == 0{
            maxTimeValue = AppValues.toSeconds(timer: AppValues.workSession)
        } else if typeSegment.selectedSegmentIndex == 1 {
            maxTimeValue = AppValues.toSeconds(timer: AppValues.shortBreak)
        } else{
            maxTimeValue = AppValues.toSeconds(timer: AppValues.longBreak)
        }
        progressBar.maxValue = CGFloat(maxTimeValue)
    }
    
    @IBAction func playButtonPressed(_ sender: Any) {
        start()
    }
    @IBAction func segmentChanged(_ sender: Any) {
        if typeSegment.selectedSegmentIndex == 0{
            maxTimeValue = AppValues.toSeconds(timer: AppValues.workSession)
        } else if typeSegment.selectedSegmentIndex == 1 {
            maxTimeValue = AppValues.toSeconds(timer: AppValues.shortBreak)
        } else{
            maxTimeValue = AppValues.toSeconds(timer: AppValues.longBreak)
        }
        if timerRunning{
            resetTimer()
        }
        
        progressBar.maxValue = CGFloat(maxTimeValue)
    }
    
    
    
    func resetTimer(){
        progressBar.value = 0
        timeValue = 0
        timer.invalidate()
        timerRunning = false
        playButton.setTitle("Start", for: .normal)
    }
    @IBAction func quoteButtonPressed(_ sender: Any) {
        quoteClient.getQuoteOfTheDay { (quote, error) in
            if error != nil{
                DispatchQueue.main.async {
                    self.showError(error: error!)
                }
            } else{
                DispatchQueue.main.async {
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "quoteVC") as! QuoteViewController
                    vc.quote = quote
                    self.present(vc, animated: true, completion: nil)
                }
            }
        }
        
    }
    
    func start(){
        if timerRunning{
            resetTimer()
        } else{
            AudioServicesPlaySystemSound(1113)
            timerRunning = true
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
            playButton.setTitle("Stop", for: .normal)
        }
        
    }
    
    @objc func updateTimer(){
        timeValue += 1
        progressBar.value = CGFloat(timeValue)
        if (timeValue == maxTimeValue){
            AudioServicesPlaySystemSound(1304);
            resetTimer()
        }
    }
    func  setView() {
        progressBar.valueIndicator = ""
        progressBar.outerRingColor = ColorPalette.orange
        progressBar.innerRingColor = ColorPalette.green
        self.view.backgroundColor = ColorPalette.spaceGray
        container.backgroundColor = ColorPalette.spaceGray
        progressBar.fontColor = .white
        progressBar.font.withSize(40)
        progressBar.font = progressBar.font.withSize(40)
        playButton.tintColor = ColorPalette.orange
        typeSegment.tintColor = ColorPalette.lightGray
        quoteButton.tintColor = ColorPalette.green
        progressBar.maxValue = CGFloat(AppValues.toSeconds(timer: AppValues.workSession))
        progressBar.value = 0
        playButton.setTitle("Start", for: .normal)
        errorLabel.textColor = ColorPalette.orange
        errorLabel.isHidden = true
    }
    
    func startWiggling() {
        quoteButton.isHidden = false
        let angle = 0.1
        let wiggle = CAKeyframeAnimation(keyPath: "transform.rotation.z")
        wiggle.values = [-angle, angle]
        wiggle.autoreverses = true
        wiggle.duration = 0.1
        wiggle.repeatCount = Float.infinity
        quoteButton.layer.add(wiggle, forKey: "wiggle")
    }
    
    func showError(error : String){
        errorLabel.text = error
        errorLabel.isHidden = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.errorLabel.isHidden = true
        }
    }
    
    
    @IBAction func settingsPressed(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "settingsVC") as! SettingsViewController
        self.present(vc, animated: true, completion: nil)
    }
    
    
}

