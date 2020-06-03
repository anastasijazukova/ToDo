//
//  ToDoTableViewController.swift
//  ToDo
//
//  Created by anastasija.zukova on 30/05/2020.
//  Copyright © 2020 Accenture. All rights reserved.
//

import UIKit
import CoreData

class ToDoTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    // MARK: Properties
    
    var resultsController: NSFetchedResultsController<Todo>!
    let coreDataStack = CoreDataStack()
    var dateFormatter: DateFormatter {
        var df = DateFormatter()
        df.setLocalizedDateFormatFromTemplate("d MMM, yyyy")
        return df
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //let container = NSPersistentContainer(name: "Todo")
        let container = (UIApplication.shared.delegate as! AppDelegate).persistentContainer
        let context: NSManagedObjectContext = container.viewContext
        // Request
        let request: NSFetchRequest<Todo> = Todo.fetchRequest()
        let sortDescriptors = NSSortDescriptor(key: "date", ascending: true)
        
        // Init
        request.sortDescriptors = [sortDescriptors]
        resultsController = NSFetchedResultsController(
            fetchRequest: request,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        resultsController.delegate = self
        
        // Fetch
        do {
            try resultsController.performFetch()
        } catch {
            print ("Perform fetch error \(error)")
        }
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    // MARK: - Table view data source
    
    @IBOutlet var ToDoTable: UITableView!
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return resultsController.sections?[section].numberOfObjects ?? 0
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ToDoTable.dequeueReusableCell(withIdentifier: "ToDoCell", for: indexPath)
        // Configure the cell
        let todo = resultsController.object(at: indexPath)
        // MARK: Add date label
        let date = todo.date
        //let dateString: String? = dateFormat.string(from: todo.date ?? nil)
        cell.textLabel?.text = dateFormatter.string(from: date!)
        cell.detailTextLabel?.text = todo.title
        //cell.textLabel?.text = dateString
        
        
        return cell
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .automatic)
                tableView.reloadData()
            }
        default:
            break
        }
    }
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .destructive, title: "Done") { (action, view, completion) in
            // TODO: Mark as done
            completion(true)
        }
        let container = (UIApplication.shared.delegate as! AppDelegate).persistentContainer
        let context: NSManagedObjectContext = container.viewContext
        let todo = Todo(context: context)
        
        

        action.backgroundColor = .green
        action.image = UIImage(systemName: "checkmark", withConfiguration: .none)
        return UISwipeActionsConfiguration(actions: [action])
        
    }
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completion) in
            // TODO: Delete todo
            completion(true)
        }
        let container = (UIApplication.shared.delegate as! AppDelegate).persistentContainer
           let context: NSManagedObjectContext = container.viewContext
           let todo = Todo(context: context)
        context.delete(todo)
        action.backgroundColor = .red
        action.image = UIImage(systemName: "trash", withConfiguration: .none)
        return UISwipeActionsConfiguration(actions: [action])
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    
}
// Get the new view controller using segue.destination.
// Pass the selected object to the new view controller.








