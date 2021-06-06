//
//  LogInViewController.swift
//  Flash Chat
//
//  This is the view controller where users login


import UIKit
import Firebase


class LogInViewController: UIViewController {

    //MARK: - Properties
    
    @IBOutlet var emailTextfield: UITextField!
    @IBOutlet var passwordTextfield: UITextField!
    
    //MARK: - View
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    //MARK: - Log-inProcess
   
    @IBAction func logInPressed(_ sender: AnyObject) {
        Auth.auth().signIn(withEmail: emailTextfield.text!, password: passwordTextfield.text!) { (use, error) in
            if error != nil {
                let alertFailed = UIAlertController(title: "Login", message: "Login failed, try again later", preferredStyle: UIAlertController.Style.alert)
                self.present(alertFailed, animated: true, completion: nil)
            } else {
                let alertSuccessful = UIAlertController(title: "Login", message: "Login sucessfully", preferredStyle: UIAlertController.Style.alert)
                self.present(alertSuccessful, animated: true, completion: nil)
                self.performSegue(withIdentifier: "goToChat", sender: self)
            }
        }
    }
    


    
}  
