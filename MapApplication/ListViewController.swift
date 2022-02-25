//
//  ListViewController.swift
//  MapApplication
//
//  Created by yunus oktay on 25.02.2022.
//

import UIKit
import CoreData

class ListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var nameSet = [String]()
    var idSet = [UUID]()
    var selectedPlaceName = ""
    var selectedPlaceId: UUID?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        
        getData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(getData), name: NSNotification.Name("newPlaceCreated"), object: nil)
    }
    
    
    
    @objc func getData() {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Place")
        request.returnsObjectsAsFaults = false
        
        do {
            
            let results = try context.fetch(request)
            
            if results.count > 0 {
                
                nameSet.removeAll(keepingCapacity: false)
                idSet.removeAll(keepingCapacity: false)
                
                for sonuc in results as! [NSManagedObject] {
                    if let name = sonuc.value(forKey: "name") as? String {
                        nameSet.append(name)
                    }
                    
                    if let id = sonuc.value(forKey: "id") as? UUID {
                        idSet.append(id)
                    }
                }
                
                tableView.reloadData()
                
            }
            
        } catch {
            print("hata")
        }
        
    }
    
    @objc func addButtonTapped() {
        selectedPlaceName = ""
        performSegue(withIdentifier: "toMapsVC", sender: nil)
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nameSet.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = nameSet[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedPlaceName = nameSet[indexPath.row]
        selectedPlaceId = idSet[indexPath.row]
        performSegue(withIdentifier: "toMapsVC", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toMapsVC" {
            let destinationVC = segue.destination as! MapsViewController
            destinationVC.selectedName = selectedPlaceName
            destinationVC.selectedId = selectedPlaceId
        }
    }
    
}
