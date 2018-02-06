//
//  AddPostViewController.swift
//  Instagram
//
//  Created by Samuel Carbone on 2/4/18.
//  Copyright © 2018 Samuel Carbone. All rights reserved.
//

import UIKit
import Firebase
class AddPostViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let postsRef = Firestore.firestore().collection("posts")
    var imagePicked = false
    @IBOutlet weak var caption: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let editedImage = info[UIImagePickerControllerEditedImage] as! UIImage
        imageView.image = editedImage
        imagePicked = true
        dismiss(animated: true, completion: nil)
    }
    
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer){
        let controller = UIImagePickerController()
        controller.allowsEditing = true
        controller.delegate = self
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            print("Camera is available 📸")
            controller.sourceType = .camera
        } else {
            print("Camera 🚫 available so we will use photo library instead")
            controller.sourceType = .photoLibrary
        }
        present(controller, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func share(_ sender: UIButton) {
        if !(caption.text?.isEmpty)! && imagePicked{
            let uid = Auth.auth().currentUser?.uid
            let imageData:Data =  UIImageJPEGRepresentation((imageView.image!), 0.2)!
            let base64 = imageData.base64EncodedString()
            postsRef.addDocument(data: [
                "caption":caption.text!,
                "user":uid as Any,
                "image":base64,
                "time":Date()
                ], completion: { (err) in
                if err != nil {
                    let alert = UIAlertController(title: "Error", message: err?.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
                else {
                    self.navigationController?.popViewController(animated: true)
                    self.dismiss(animated: true, completion: nil)
                }
            })
        } else{
            let alert = UIAlertController(title: "Error", message: "Missing image or caption", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    @IBAction func cancel(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
}
