//
//  LogInViewController.swift
//  Flash Chat
//
//  This is the view controller where users login


import UIKit
import Firebase
import SVProgressHUD
import GoogleSignIn
import MaterialComponents.MaterialTextControls_OutlinedTextAreas
import MaterialComponents.MaterialTextControls_OutlinedTextFields

class LogInViewController: UIViewController {

    //MARK: - Properties
    
    @IBOutlet weak var signInButton: GIDSignInButton!
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
                
        SVProgressHUD.show()
        self.view.endEditing(true)
        
        Auth.auth().signIn(withEmail: emailTextfield.text!, password: passwordTextfield.text!) { (use, error) in 
            if error != nil {
                let alertFailed = UIAlertController(title: "Login", message: "Login failed, try again later", preferredStyle: UIAlertController.Style.alert)
                SVProgressHUD.dismiss()
                self.present(alertFailed, animated: true, completion: nil)
                let when = DispatchTime.now() + 1
                DispatchQueue.main.asyncAfter(deadline: when){
                  alertFailed.dismiss(animated: true, completion: nil)
                }
            } else {
                SVProgressHUD.dismiss()
                self.performSegue(withIdentifier: "goToChat", sender: self)
            }
        }
    }
}  
