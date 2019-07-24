//
//  LoginViewController.swift
//  Cashout
//


import UIKit

class LoginViewController: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var txtFieldEmail: UITextField! {
        didSet {
            txtFieldEmail.setIconWithTint(#imageLiteral(resourceName: "email"), tintColor: #colorLiteral(red: 0, green: 0.5490196078, blue: 0.2549019608, alpha: 1))
        }
    }
    @IBOutlet weak var txtFieldPassword: UITextField! {
        didSet {
            txtFieldPassword.setIconWithTint(#imageLiteral(resourceName: "password"), tintColor: #colorLiteral(red: 0, green: 0.5490196078, blue: 0.2549019608, alpha: 1))
        }
    }
    @IBOutlet weak var btnLogin: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.renderUI()
        self.txtFieldEmail.text = "agente@dolciaria.it"
        self.txtFieldPassword.text = "passwordtemporanea"
        if TokenManager.shared.userToken != nil { // User is logged in
            self.redirectToHome()
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    func renderUI () {
        txtFieldEmail.dropShadow(color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1) , offset: CGSize(width:1.0,height: 2.0))
        txtFieldPassword.dropShadow(color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), offset: CGSize(width:1.0,height: 2.0))
    }
    
    func textFieldShouldReturn(_ scoreText: UITextField) -> Bool {
        self.txtFieldEmail.resignFirstResponder()
        self.txtFieldPassword.resignFirstResponder()
        return true
    }
    
    // MARK: Login methods
    @IBAction func loginAction(_ sender: UIButton) {
        txtFieldEmail.resignFirstResponder()
        txtFieldPassword.resignFirstResponder()
        
        let emailTupple = txtFieldEmail.text!
        if emailTupple.trimSpace().isEmpty {
            Constants.showAlert(message: String.LoginErrorMessages.strBlankEmail)
            return
        } else if !Constants.isValidEmail(email: emailTupple.trimSpace()) {
            Constants.showAlert(message: String.LoginErrorMessages.strInvalidEmail)
            return
        } else if (txtFieldPassword.text!).isEmpty == true {
            Constants.showAlert(message: String.LoginErrorMessages.strEmptyPassword)
            return
        }
        else {
            Constants.showLoader()
            UserManager.shared.makePostCallWithAlamofire(email: (self.txtFieldEmail.text!.trimSpace()), password: self.txtFieldPassword.text!) { (success) in
                Constants.hideLoader()
                if (success) {
                    self.redirectToHome()
                }
            }
        }
    }
    
    private func redirectToHome () {
        print(UIDevice.current.userInterfaceIdiom)
        if UIDevice.current.userInterfaceIdiom == .pad {
            let sb = UIStoryboard(name: Constants.StoryBoard.homeIpadSB, bundle: nil)
            if let vc = sb.instantiateViewController(withIdentifier: "SplitVC") as? UISplitViewController {
                self.navigationController?.present(vc, animated: true, completion: nil)
            }
        }
        else {
            let sb = UIStoryboard(name: Constants.StoryBoard.homeSB, bundle: nil)
            if let vc = sb.instantiateViewController(withIdentifier: Constants.ViewControllerIdentifier.customerListViewController) as? CustomerListViewController {
                self.navigationController?.setViewControllers([vc], animated: true)
            }
            
        }
    }
    
    
}
