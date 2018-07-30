//
//  CategoryTableViewController.swift
//  Todoey
//
//  Created by Darran Edmundson on 2018-07-28.
//  Copyright © 2018 EDM Studio Inc. All rights reserved.
//

import UIKit
import RealmSwift
import SwipeCellKit

class CategoryTableViewController: UITableViewController {

    let realm = try! Realm()
    var categories : Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 80.0
        loadCategories()
    }


    // MARK: TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as! SwipeTableViewCell
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No categories added yet"

        cell.delegate = self
        
        return cell
    }
    
    
    // MARK: TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
        
    }
    
    
    // MARK: Data Manipulation Methods
    
    func saveCategories(category: Category) {
        
        do {
            try realm.write {
                realm.add(category)
                }
        } catch {
            print("Error saving category, \(error)")
        }
        
        tableView.reloadData()
        
    }
    
    
    func loadCategories() {
      
        categories = realm.objects(Category.self)
        tableView.reloadData()
    }
    
    
  
    // MARK: Add New Categories
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            let newCategory = Category()
            newCategory.name = textField.text!
            self.saveCategories(category: newCategory)
        }
        
        alert.addTextField { (alertTextField) in
            textField = alertTextField
            alertTextField.placeholder = "Enter category"
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
}

// MARK: Swipe Cell Delegate Methods

extension CategoryTableViewController : SwipeTableViewCellDelegate {
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {

        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            // handle action by updating model with deletion
            if let categoryForDeletion = self.categories?[indexPath.row] {
                do {
                    try self.realm.write {
                        self.realm.delete(categoryForDeletion)
                    }
                } catch {
                    print("Error deleting category, \(error)")
                }
                
                //tableView.reloadData()
            }
            
        }
        
        // customize the action appearance
        deleteAction.image = UIImage(named: "delete-icon")
        
        return [deleteAction]
    }
    
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        return options
    }
    
}
