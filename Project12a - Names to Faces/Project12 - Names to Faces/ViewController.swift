//
//  ViewController.swift
//  Project12 - Names to Faces
//
//  Created by Ahmed Nagy on 26/02/2021.
//

import UIKit

class ViewController: UICollectionViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var people = [Person]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewPerson))
        
        let defaults = UserDefaults.standard
        if let savedPeople = defaults.object(forKey: "people") as? Data {
            if let decodedPeople = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(savedPeople) as? [Person] {
                people = decodedPeople
            }
        }
    }
    
    // MARK:- Implementing CollecionView methods
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return people.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Person", for: indexPath) as? PersonCell else {
            fatalError("Unable to dequeue PersonCell.")
        }
        
        let person = people[indexPath.item]
        cell.name.text = person.name
        
        let path = getDocumentsDirectory().appendingPathComponent(person.image)
        cell.imageView.image = UIImage(contentsOfFile: path.path)
        
        cell.imageView.layer.borderColor = UIColor(white: 0, alpha: 0.3).cgColor
        cell.imageView.layer.borderWidth = 2
        cell.imageView.layer.cornerRadius = 3
        cell.layer.cornerRadius = 7
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let person = people[indexPath.item]
        
        if person.name == "Click to rename" {
            let ac = UIAlertController(title: "Rename person", message: nil, preferredStyle: .alert)
            ac.addTextField()
            let okButton = UIAlertAction(title: "Ok", style: .default) { [weak self, weak ac] _ in
                guard let newName = ac?.textFields?[0].text else { return }
                person.name = newName
                self?.save()
                self?.collectionView.reloadData()
            }
            let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            ac.addAction(okButton)
            ac.addAction(cancelButton)
            
            present(ac, animated: true, completion: nil)
        } else {
            let editAC = UIAlertController(title: "Edit Person", message: "Peform you edits.", preferredStyle: .alert)
            editAC.addTextField()
            
            // rename button
            let renameAction = UIAlertAction(title: "Rename", style: .default) { [weak self, weak editAC] _ in
                guard let editedName = editAC?.textFields?[0].text else { return }
                // update the person name
                person.name = editedName
                self?.collectionView.reloadData()
            }
            // delete button
            let deleteButton = UIAlertAction(title: "Delete", style: .cancel) { _ in
                self.people.remove(at: indexPath.item)
                self.collectionView.reloadData()
            }
            
            // add both actions to the editAC
            editAC.addAction(renameAction)
            editAC.addAction(deleteButton)
            
            present(editAC, animated: true, completion: nil)
        }
    }
    
    // Using UIImagePickerController class to add images to our app
    @objc func addNewPerson() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.sourceType = .camera
        }
        picker.delegate = self
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let image = info[.editedImage] as? UIImage else { return }
        
        let imageName = UUID().uuidString
        let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)
        
        if let jpegData = image.jpegData(compressionQuality: 1) {
            try? jpegData.write(to: imagePath)
        }
        let person = Person(name: "Click to rename", image: imageName)
        people.append(person)
        save()
        collectionView.reloadData()
        
        dismiss(animated: true, completion: nil)
    }
    
    // Get the user's document directory
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func save() {
        if let savedData = try? NSKeyedArchiver.archivedData(withRootObject: people, requiringSecureCoding: false) {
            let userDefaults = UserDefaults.standard
            userDefaults.setValue(savedData, forKey: "people")
        }
    }
}

