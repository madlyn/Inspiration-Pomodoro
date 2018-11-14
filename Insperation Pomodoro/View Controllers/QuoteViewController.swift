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
    
    @IBOutlet weak var textArea: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = ColorPalette.spaceGray
        self.textArea.backgroundColor = ColorPalette.spaceGray
        
        self.textArea.textColor = .white
        textArea.text = quote.quoteBody + "\n~" + quote.author

    }
    
    @IBAction func doneButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func actionButtonPressed(_ sender: Any) {
        var textToShare =  textArea.text = quote.quoteBody + "\n~" + quote.author
        let activity = UIActivityViewController(activityItems: [textToShare], applicationActivities: nil)
        activity.popoverPresentationController?.sourceView = self.view
        self.present(activity, animated: true, completion: nil)
    }
    

}
