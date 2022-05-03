//
//  ViewController.swift
//  HitList
//
//  Created by Анастасия Восколович on 26.04.2022.
//
import CoreData
import UIKit

class ViewController: UIViewController, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
        let person = people[indexPath.row]
        cell.textLabel!.text = (person.value(forKey: "name") as! String)
        return cell
    }
    func saveName(name: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Person", in: managedContext)!
        let person = NSManagedObject(entity: entity, insertInto: managedContext)
        person.setValue(name, forKeyPath: "name")
        do {
            try managedContext.save()
            people.append(person)
          } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
          }
    }
    
    @IBOutlet weak var tableView: UITableView!
    var people = [NSManagedObject]()
    

    @IBAction func addName(_ sender: AnyObject) {
        let alert = UIAlertController(title: "New name", message: "Add a new name", preferredStyle: .alert)
        let saveAction = UIAlertAction(title: "Save", style: .default) { (action: UIAlertAction!) -> Void in
            let textField = alert.textFields![0]
            self.saveName(name: textField.text!)
            self.tableView.reloadData()
          }
        let cancelAction = UIAlertAction(title: "Cancel", style: .default) { (action: UIAlertAction!) -> Void in }
        alert.addTextField { (textField: UITextField!) -> Void in }
          alert.addAction(saveAction)
          alert.addAction(cancelAction)

        present(alert, animated: true, completion: nil)
       
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "\"The List\""
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
      }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return people.count
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
          }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Person")
        do {
            people = try managedContext.fetch(fetchRequest)
          } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
          }
    }

     
}

