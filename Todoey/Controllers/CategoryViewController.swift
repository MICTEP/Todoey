//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Ivan Trubka on 10.05.2018.
//  Copyright © 2018 Ivan Trubka. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
    //MARK: - Properties
    
    var categoryArray = [Category]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        loadCategories()

    }
    
    //MARK: - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return categoryArray.count
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        cell.textLabel?.text = categoryArray[indexPath.row].name
        
        return cell
        
    }
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToItems", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray[indexPath.row]
        }
        
    }
    
    //MARK: - Data Manipulation Methods
    
    func saveCategory() {
        
        do {
            try context.save()
        } catch {
            print("Error saving category context \(error)")
        }
        
        tableView.reloadData()
        
    }
    
    func loadCategories() {
        
        let request: NSFetchRequest<Category> = Category.fetchRequest()
        
        do {
            categoryArray = try context.fetch(request)
        } catch {
            print("Error fetching category data \(error)")
        }
        
        tableView.reloadData()
        
    }
    
    //MARK: - Add new category
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var addedCategory = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: nil, preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            let newCategory = Category(context: self.context)
            
            newCategory.name = addedCategory.text
            
            self.categoryArray.append(newCategory)
            
            self.saveCategory()
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new category"
            addedCategory = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    
}
