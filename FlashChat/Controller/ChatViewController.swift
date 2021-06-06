//
//  ViewController.swift
//  Flash Chat
//
//  Created by Angela Yu on 29/08/2015.
//  Copyright (c) 2015 London App Brewery. All rights reserved.
//

import UIKit
import Firebase


class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    //MARK: -Properties

    @IBOutlet var heightConstraint: NSLayoutConstraint!
    @IBOutlet var sendButton: UIButton!
    @IBOutlet var messageTextfield: UITextField!
    @IBOutlet var messageTableView: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        messageTableView.delegate = self
        messageTableView.dataSource = self
        messageTextfield.delegate = self
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tableViewTapped))
        messageTableView.addGestureRecognizer(tapGesture)
        
        messageTableView.register(UINib(nibName: "MessageCell", bundle: nil), forCellReuseIdentifier: "customMessageCell")
        configureTableView()
    }

    
    //MARK: - TableViewDataSource
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customMessageCell", for: indexPath) as! CustomMessageCell
        let messageArray = ["Welcome", "To", "Flashchat"]
            
        cell.messageBody.text = messageArray[indexPath.row]
        
        return cell
    }
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    
    //MARK: - tableViewTapped
    
    @objc func tableViewTapped() {
        messageTextfield.endEditing(true)
    }
    
    //MARK: - ConfigureTableView

    func configureTableView() {
        messageTableView.rowHeight = UITableView.automaticDimension
        messageTableView.estimatedRowHeight = 120.0
    }
    
    //MARK: - textFieldDidBegin
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.5){
            self.heightConstraint.constant = 360
            self.view.layoutIfNeeded()
        }
    }
    
    //MARK: - textFieldDidEnd
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.5){
            self.heightConstraint.constant = 50
            self.view.layoutIfNeeded()
        }
    }


    //MARK: - Send&RecieveFirebase
    
    @IBAction func sendPressed(_ sender: AnyObject) {
        messageTextfield.endEditing(true)
        sendButton.isEnabled = false
        sendButton.isHidden = true
        
        let messagesDB = Database.database().reference().child("Messages")
        let messagesDictionary = ["Sender": Auth.auth().currentUser?.email, "MessageBody": messageTextfield.text!]
        
        messagesDB.childByAutoId().setValue(messagesDictionary) {
            (error, reference) in
            if error != nil {
                print(error!)
            } else {
                print("message sent")
                self.sendButton.isEnabled = true
                self.sendButton.isHidden = false
                self.messageTextfield.text = ""
                
                let alert = UIAlertController(
                                      title: "Message Sent",
                                      message: "your Message has been sent successfully",
                                      preferredStyle: UIAlertController.Style.alert
                                    )
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    //TODO: Create the retrieveMessages method here:
    
    

    //MARK: - LogOutProcess
    
    
    @IBAction func logOutPressed(_ sender: AnyObject) {
        do {
       try Auth.auth().signOut()
            navigationController?.popToRootViewController(animated: true)
        } catch {
            print("error")
        }
    }
}
