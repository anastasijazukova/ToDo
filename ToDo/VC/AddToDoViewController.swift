//
//  AddToDoViewController.swift
//  ToDo
//
//  Created by anastasija.zukova on 30/05/2020.
//  Copyright © 2020 Accenture. All rights reserved.
//

import UIKit
import CoreData

class AddToDoViewController: UIViewController {
    
    // MARK: Properties
    
    
    // MARK: Outlets
    
    @IBOutlet weak var textEdit: UITextView!
    
    @IBOutlet weak var dateSelect: UIDatePicker!
    
    @IBOutlet weak var doneButton: UIButton!
    
    //@IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let container = (UIApplication.shared.delegate as! AppDelegate).persistentContainer
        
        
        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(AddToDoViewController.keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil)
        textEdit.becomeFirstResponder()
    }
    // MARK: Actions
    
    @objc func keyboardWillShow(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            print("")
            /*if self.view.frame.origin.y == 0{
             self.view.frame.origin.y -= keyboardSize.height
             }*/
        }
        /*bottomConstraint.constant = self.view.frame.origin.y
         UIView.animate(withDuration: 0.3) {
         self.view.layoutIfNeeded()
         }*/
    }
    let coreDataStack = CoreDataStack()
    
    
    fileprivate func dismissAndResign() {
        dismiss(animated: true)
        textEdit.resignFirstResponder()
    }
    
    @IBAction func cancel(_ sender: UIButton) {
        dismissAndResign()
    }
    
    @IBAction func done(_ sender: UIButton) {
        let container = (UIApplication.shared.delegate as! AppDelegate).persistentContainer
        let context: NSManagedObjectContext = container.viewContext
        
        let date = dateSelect.date
        guard let title = textEdit.text, !title.isEmpty else {
            return 
        }
        
        let todo = Todo(context: context)
        todo.date = date
        todo.task = title
        
        do {
            try context.save()
            dismissAndResign()
        } catch {
            print("Error saving to-do: \(error)")
        }
        
        
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

