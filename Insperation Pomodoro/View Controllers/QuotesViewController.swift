//
//  QuotesViewController.swift
//  Insperation Pomodoro
//
//  Created by Lyn Almasri on 11/15/18.
//  Copyright © 2018 lynmasri. All rights reserved.
//

import UIKit
import CoreData
class QuotesViewController: UIViewController, UITableViewDataSource, NSFetchedResultsControllerDelegate, UITableViewDelegate {
    var dataController: DataController!
    var fetchedResultsController:NSFetchedResultsController<Quote>!
    
    @IBOutlet weak var table: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        table.backgroundColor = ColorPalette.spaceGray
        view.backgroundColor = ColorPalette.spaceGray
        self.navigationController?.title = "Favorite Quotes"
        self.title = "Favorite Quotes"
        let delegate = UIApplication.shared.delegate as! AppDelegate
        dataController = delegate.dataController
        setupFetchedResultsController()
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupFetchedResultsController()
        table.reloadData()
    }
    
    fileprivate func setupFetchedResultsController() {
        let fetchRequest:NSFetchRequest<Quote> = Quote.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchRequest.includesPendingChanges = false
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: dataController.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        do {
            
            try fetchedResultsController.performFetch()
        } catch {
            fatalError("The fetch could not be performed: \(error.localizedDescription)")
        }
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        fetchedResultsController = nil
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let quote = fetchedResultsController.object(at: indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: "quoteCell") as! UITableViewCell
        cell.backgroundColor = ColorPalette.spaceGray
        cell.textLabel?.text = quote.author
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        cell.detailTextLabel?.text = formatter.string(from: quote.date!)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete: deleteQuote(at: indexPath)
        default: ()
        }
    }
    func deleteQuote(at indexPath: IndexPath) {
        let quote = fetchedResultsController.object(at: indexPath)
        dataController.viewContext.delete(quote)
        try? dataController.viewContext.save()
        table.reloadData()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        table.deselectRow(at: indexPath, animated: true)
        let quote = fetchedResultsController.object(at: indexPath)
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "quoteVC") as! QuoteViewController
        vc.quote = quote
        vc.isNew = false
//        self.present(vc, animated: true, completion: nil)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .delete:
            table.deleteRows(at: [indexPath!], with: .fade)
            break
        default: break
        }
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        table.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        table.endUpdates()
    }
}


