//
//  QuoteViewController.swift
//  Insperation Pomodoro
//
//  Created by Lyn Almasri on 11/14/18.
//  Copyright © 2018 lynmasri. All rights reserved.
//

import UIKit

class QuoteViewController: UIViewController {
    var quote : Quote!
    var isNew : Bool!
    var dataController:DataController!
    var appDelegate : AppDelegate!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var customNavigationBar: UINavigationBar!
    
    @IBOutlet weak var textArea: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = ColorPalette.spaceGray
        self.textArea.backgroundColor = ColorPalette.spaceGray
        if !isNew{
            saveButton.isHidden = true
            customNavigationBar.isHidden = true
            self.title = quote.author
            var actionButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(presentActivity))
            self.navigationItem.rightBarButtonItem = actionButton
        }
        
        self.textArea.textColor = .white
        if let body = quote.quoteBody, let author = quote.author{
            textArea.text = body + "\n~" + author
        }
        
        appDelegate = UIApplication.shared.delegate as? AppDelegate
        dataController = appDelegate.dataController

    }
    
    @IBAction func doneButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @objc func presentActivity(){
        var textToShare = ""
        if let body = quote.quoteBody, let author = quote.author{
            textToShare = body + "\n~" + author
        }
        let activity = UIActivityViewController(activityItems: [textToShare], applicationActivities: nil)
        activity.popoverPresentationController?.sourceView = self.view
        self.present(activity, animated: true, completion: nil)
    }
    @IBAction func actionButtonPressed(_ sender: Any) {
       presentActivity()
    }
    
    @IBAction func savePressed(_ sender: Any) {
        do{
            try self.dataController.viewContext.save()
            saveButton.isEnabled = false
            saveButton.setTitle("Saved!", for: .normal)
        }catch{
            self.saveButton.setTitle("Error: Could not save", for: .normal)
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.saveButton.setTitle("Save", for: .normal)
            }
        }
        
        
        
    }
    
    
}
