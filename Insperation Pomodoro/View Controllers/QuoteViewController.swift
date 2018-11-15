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
    
    @IBOutlet weak var textArea: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = ColorPalette.spaceGray
        self.textArea.backgroundColor = ColorPalette.spaceGray
        if !isNew{
            saveButton.isHidden = true
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
    
    @IBAction func actionButtonPressed(_ sender: Any) {
        var textToShare = ""
        if let body = quote.quoteBody, let author = quote.author{
             textToShare = body + "\n~" + author
        }
        let activity = UIActivityViewController(activityItems: [textToShare], applicationActivities: nil)
        activity.popoverPresentationController?.sourceView = self.view
        self.present(activity, animated: true, completion: nil)
    }
    
    @IBAction func savePressed(_ sender: Any) {
        try? self.dataController.viewContext.save()
    }
    
    
}
