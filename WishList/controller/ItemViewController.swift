//
//  ItemViewController.swift
//  WishList
//
//  Created by 钱正轩 on 2020/11/2.
//

import UIKit
import os.log

class ItemViewController: UIViewController {
    
    //MARK: Properties
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var ratingControl: RatingControl!
    
    var item: Item?
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        nameTextField.delegate = self
        
        if let item = item {
            navigationItem.title = item.name
            nameTextField.text = item.name
            photoImageView.image = item.photo
            ratingControl.rating = item.rating
        }
        
        updateSaveButtonState()
    }
    
    //MARK: Navigation
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        let isPresentingInAddItemMode = presentingViewController is UINavigationController
        if isPresentingInAddItemMode{
            dismiss(animated: true, completion: nil)
        } else if let owningNavigationController = navigationController {
            owningNavigationController.popViewController(animated: true)
        } else {
            fatalError("The ItemViewController is not inside a navigation controller")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return
        }
        let name = nameTextField.text ?? ""
        let photo = photoImageView.image
        let rating = ratingControl.rating
        item = Item(name: name, photo: photo, rating: rating)
        
    }

    //MARK: Actions
    @IBAction func selectImageFromPhotoLibrary(_ sender: UITapGestureRecognizer) {
        nameTextField.resignFirstResponder()
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
    
    //MARK: Private Methods
    
    private func updateSaveButtonState() {
        let text = nameTextField.text ?? ""
        saveButton.isEnabled = !text.isEmpty
    }
}

extension ItemViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateSaveButtonState()
        navigationItem.title = textField.text
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        saveButton.isEnabled = false
    }
}

extension ItemViewController: UIImagePickerControllerDelegate{
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        photoImageView.image = selectImage
        dismiss(animated: true, completion: nil)
    }
    
}

extension ItemViewController: UINavigationControllerDelegate{
    
}
