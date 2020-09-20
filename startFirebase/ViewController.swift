//
//  ViewController.swift
//  startFirebase
//
//  Created by 諸星水晶 on 2020/09/14.
//  Copyright © 2020 Mizuki Morohoshi. All rights reserved.
//

import UIKit
import FirebaseDatabase

class ViewController: UIViewController {
    
    @IBOutlet weak var textView: UITextView!
    
    @IBOutlet weak var nameInputView: UITextField!
    
    @IBOutlet weak var messageInputView: UITextField!

    
    
    @IBOutlet weak var inputViewBottomMargin: NSLayoutConstraint!
    
    var databaseRef:DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        databaseRef = Database.database().reference()
        
        databaseRef.observe(.childAdded, with: { snapshot in
            if let obj = snapshot.value as? [String : AnyObject], let name = obj["name"] as? String, let message = obj["message"] {
                let currentText = self.textView.text
                self.textView.text = (currentText ?? "") + "\n\(name) : \(message)"
            }
        })
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tapGesture)
        
        
        
    }
    
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            } else {
                let suggestionHeight = self.view.frame.origin.y + keyboardSize.height
                self.view.frame.origin.y -= suggestionHeight
            }
        }
    }
    
    @objc func keyboardWillHide() {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    
    

    @IBAction func tappedSendButton(_ sender: Any) {
        
        view.endEditing(true)

        if let name = nameInputView.text, let message = messageInputView.text {
            let messageData = ["name": name, "message": message]
            databaseRef.childByAutoId().setValue(messageData)

            messageInputView.text = ""
        }
    }
    
    
    
    
    
    
}

extension ViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
}
