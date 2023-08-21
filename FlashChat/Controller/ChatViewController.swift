//
//  ViewController.swift
//  Flash Chat
//
//

import UIKit
import Firebase


class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    //MARK: - Properties
    
    var messageArray: [Message] = [Message]()
    
    @IBOutlet var heightConstraint: NSLayoutConstraint!
    @IBOutlet var waveHand: UIButton!
    @IBOutlet var sendButton: UIButton!
    @IBOutlet var messageTextfield: UITextField!
    @IBOutlet var messageTableView: UITableView!
    
    //MARK: - View
    
    override func viewDidLoad() {
        super.viewDidLoad()
        waveHand.isHidden = false
        sendButton.isHidden = true
        self.navigationItem.setHidesBackButton(true, animated: true)
        messageTableView.delegate = self
        messageTableView.dataSource = self
        messageTextfield.delegate = self
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tableViewTapped))
        messageTableView.addGestureRecognizer(tapGesture)
        
        messageTableView.register(UINib(nibName: "MessageCell", bundle: nil), forCellReuseIdentifier: "customMessageCell")
        configureTableView()
        
        retrieveMessages()
        
        messageTableView.separatorStyle = .none
    }
    
    
    //MARK: - TableViewDataSource
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customMessageCell", for: indexPath) as! CustomMessageCell
        
        cell.messageBody.text = messageArray[indexPath.row].messageBody
        cell.senderUsername.text = messageArray[indexPath.row].sender
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageArray.count
    }
    
    
    //tableViewTapped
    
    @objc func tableViewTapped() {
        messageTextfield.endEditing(true)
    }
    
    //MARK: - TableViewConfig
    
    func configureTableView() {
        messageTableView.rowHeight = UITableView.automaticDimension
        messageTableView.estimatedRowHeight = 120.0
    }
    
    //MARK: - textFieldDidBegin
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        waveHand.isHidden = true
        sendButton.isHidden = false
        
        UIView.animate(withDuration: 0.5) {
            self.heightConstraint.constant = 360
            self.view.layoutIfNeeded()
        }
    }
    
    //MARK: - textFieldDidEnd
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.5){
            self.sendButton.isHidden = true
            self.waveHand.isHidden = false
            self.heightConstraint.constant = 50
            self.view.layoutIfNeeded()
        }
    }
}

    //MARK: - Send&RecieveFirebase

extension ChatViewController {
    
    @IBAction func sendPressed(_ sender: AnyObject) {
        if messageTextfield.text != "" {
            
            messageTextfield.endEditing(true)
            
            let messagesDB = Database.database().reference().child("Messages")
            let messagesDictionary = ["Sender": Auth.auth().currentUser?.email, "MessageBody": messageTextfield.text]
            
            messagesDB.childByAutoId().setValue(messagesDictionary) {
                (error, reference) in
                if error != nil {
                    print(error!)
                } else {
                    print("message sent")
                    self.messageTextfield.text = ""
                }
            }
        } else {
            print("ups")
        }
    }
}
    
    //MARK: - RecieveMessages
    
extension ChatViewController {
    
    func retrieveMessages() {
        let messageDB = Database.database().reference().child("Messages")
        
        messageDB.observe(.childAdded) { (snapshot) in
            let snapshotValue = snapshot.value as! Dictionary<String, String>
            let text = snapshotValue["MessageBody"]!
            let sender = snapshotValue["Sender"]!
            let message = Message()
            
            message.messageBody = text
            message.sender = sender
            
            self.messageArray.append(message)
            self.configureTableView()
            self.messageTableView.reloadData()
        }
    }
}
    
    //MARK: - LogOutProcess
    
extension ChatViewController {

    @IBAction func logOutPressed(_ sender: AnyObject) {
        do {
       try Auth.auth().signOut()
            navigationController?.popToRootViewController(animated: true)
        } catch {
            print("error")
        }
    }
}
